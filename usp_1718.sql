use kubrick
go

/**************
creating a stored function to calculate the tariff for the randomised hes data
	issue with this data is randomness also applies to columns it shouldnt such as admiage not matching dob of different episodes with same hesid
	therefore going to use the min admiage, min classpat within each spell but group their episodes even though spell denotes 1 for each of them
		will collate the duration of their spell by summing the epidurs over the spell
		rest of group have calcualted for each episode, to get these commands to match that would have to remove the command to sum epidur over grouped hesid
***************/

IF EXISTS (SELECT * FROM sysobjects WHERE ID=OBJECT_ID(N'tariff.usp_1718TariffCalc') and OBJECTPROPERTY(id, N'IsProcedure')=1)
    BEGIN
        DROP Procedure tariff.usp_1718TariffCalc
    END
GO

CREATE PROCEDURE tariff.usp_1718TariffCalc
@tablename nvarchar(max)
as
BEGIN
SET NOCOUNT ON;
IF COL_LENGTH(''+@tablename+'', 'Tariff 17_18 (£) for spell') IS NOT NULL
BEGIN
declare @command1 nvarchar(max)
set @command1 = '
   ALTER TABLE '+@tablename+'
   DROP COLUMN [Tariff 17_18 (£) for spell]
'
exec sp_executesql @command1
END;

begin
declare @command2 nvarchar (max)
set @command2 = '
alter table '+@tablename+'
add [Tariff 17_18 (£) for spell] int
'
exec sp_executesql @command2
end


;begin
declare @command nvarchar(max)
set @command = '
with rgd
as
(
select
	hesid
	, spell
	, cast(min(admiage) as int) Admission_age
	, min(classpat) ClassPat
	, sum(cast(epidur as int)) SpellDur
	, min(admimeth) admimeth
	, HRG_code
from '+@tablename+'
group by hesid, spell, HRG_code --9999 rows
)

select
	rgd.hesid
	, rgd.spell
	, rgd.Admission_age
	, rgd.ClassPat
	, rgd.SpellDur
	, rgd.HRG_code
	, case --are they a day admission
		when rgd.ClassPat = 2 and rgd.SpellDur = 0 then c.[Day case spell tariff (£)]
		when rgd.ClassPat = 2 and rgd.SpellDur > 0 and rgd.SpellDur < c.[Ordinary elective long stay trim point (days)] then c.[Ordinary elective long stay trim point (days)]
		when rgd.ClassPat = 2 and rgd.SpellDur > 0 and rgd.SpellDur > c.[Ordinary elective long stay trim point (days)] then c.[Ordinary elective spell tariff (£)] + ((rgd.SpellDur - c.[Ordinary elective long stay trim point (days)]) * c.[Per day long stay payment (for days exceeding trim point) (£)])
		else case -- was admission elective
				when rgd.admimeth in (''11'', ''12'', ''13'', ''82'', ''83'', ''81'', ''84'', ''89'', ''98'', ''99'') then c.[Combined day case / ordinary elective spell tariff (£)] +
					case --was their duration longer than the trim point
						when rgd.SpellDur > c.[Non-elective long stay trim point (days)] then (c.[Per day long stay payment (for days exceeding trim point) (£)] * (rgd.SpellDur - c.[Ordinary elective long stay trim point (days)]))
						else 0
					end
				else
					case --stay greater than trim
						when rgd.SpellDur > c.[Non-elective long stay trim point (days)] then [Non-elective spell tariff (£)] + (c.[Per day long stay payment (for days exceeding trim point) (£)] * (rgd.SpellDur - c.[Non-elective long stay trim point (days)]))
						else
							case --does emergency tariff apply
								when c.[Reduced short stay emergency tariff _applicable?] = ''Yes'' and rgd.SpellDur < 2 and rgd.Admission_age > 18 and rgd.admimeth in (''21'', ''22'', ''23'', ''24'', ''25'', ''2A'', ''2B'', ''2C'', ''2D'', ''28'') then c.[Reduced short stay emergency tariff (£)]
								else c.[Non-elective spell tariff (£)]
							end
					end
			end
	end as [Tariff 17_18 (£) for spell]
into #temp
from rgd
	left join tariff.[Clean_17-18] c
		on rgd.HRG_code = c.[HRG code]

update '+@tablename+'
set '+@tablename+'.[Tariff 17_18 (£) for spell] = #temp.[Tariff 17_18 (£) for spell]
from #temp
	inner join '+@tablename+'
		on '+@tablename+'.[hesid] = #temp.[hesid]
'
exec sp_executesql @command;

end

begin
DECLARE @command3 nvarchar(max)
set @command3 = '
SELECT
*
FROM '+@tablename+'
'
exec sp_executesql @command3
END
END


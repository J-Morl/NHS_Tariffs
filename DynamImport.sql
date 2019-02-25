use kubrick
go


IF EXISTS (SELECT * FROM sysobjects WHERE ID=OBJECT_ID(N'Tariff.uspImportFromGrouper') and OBJECTPROPERTY(id, N'IsProcedure')=1)
    BEGIN
        DROP Procedure tariff.uspImportFromGrouper
    END
GO


CREATE PROCEDURE tariff.uspImportFromGrouper --need to know how to specify the outputted table from the grouper
	@tablename nvarchar(50)
	, @path nvarchar(max)
AS
begin
BEGIN
declare @command1 nvarchar(max)
set @command1 = '
IF OBJECT_ID('''+@tablename+''') is not null
Begin
	Drop TABLE '+@tablename+'
END
'
exec sp_executesql @command1
end

;begin
declare @command2 nvarchar(max)
set @command2 = '
CREATE TABLE '+@tablename+'
(PROCODET	varchar(20) 
	,PROVSPNO	varchar(20)
	,EPIORDER	int
	,STARTAGE	smallint
	,SEX	tinyint
	,CLASSPAT	tinyint
	,ADMISORC	tinyint
	,ADMIMETH	varchar(50)
	,DISDEST	tinyint
	,DISMETH	tinyint
	,EPIDUR		smallint
	,MAINSPEF	smallint
	,NEOCARE	tinyint
	,TRETSPEF	smallint
	,DIAG_01	varchar(5)
	,DIAG_02	varchar(5)
	,DIAG_03	varchar(5)
	,DIAG_04	varchar(5)
	,DIAG_05	varchar(5)
	,DIAG_06	varchar(5)
	,DIAG_07	varchar(5)
	,DIAG_08	varchar(5)
	,DIAG_09	varchar(5)
	,DIAG_10	varchar(5)
	,DIAG_11	varchar(5)
	,DIAG_12	varchar(5)
	,DIAG_13	varchar(5)
	,DIAG_14	varchar(5)
	,OPER_01	varchar(5)
	,OPER_02	varchar(5)
	,OPER_03	varchar(5)
	,OPER_04	varchar(5)
	,OPER_05	varchar(5)
	,OPER_06	varchar(5)
	,OPER_07	varchar(5)
	,OPER_08	varchar(5)
	,OPER_09	varchar(5)
	,OPER_10	varchar(5)
	,OPER_11	varchar(5)
	,OPER_12	varchar(5)
	,CRITICALCAREDAYS	smallint
	,REHABILITATIONDAYS	smallint
	,SPCDAYS	smallint
	,dummy_field	bigint
	,RowNo	int
	,FCE_HRG	varchar(50)
	,GroupingMethodFlag	varchar(50)
	,DominantProcedure	varchar(500)
	,FCE_PBC	varchar(100)
	,CalcEpidur	int
	,ReportingEPIDUR	varchar(50)
	,FCETrimpoint	varchar(50)
	,FCEExcessBeddays	varchar(50)
	,SpellReportFlag	smallint
	,FCESSC_Ct	smallint
	,FCESSCs1	varchar(50)
	,FCESSCs2	varchar(50)
	,FCESSCs3	varchar(50)
	,FCESSCs4	varchar(50)
	,FCESSCs5	varchar(50)
	,FCESSCs6	varchar(50)
	,FCESSCs7	varchar(50)
	,SpellHRG	varchar(50)
	,SpellGroupingMethodFlag	varchar(50)
	,SpellDominantProcedure	varchar(50)
	,SpellPDiag	varchar(50)
	,SpellSDiag	varchar(50)
	,SpellEpisodeCount	smallint
	,SpellLOS	smallint
	,ReportingSpellLOS	varchar(50)
	,SpellTrimpoint	smallint
	,SpellExcessBeddays	smallint
	,SpellCCDays	smallint
	,SpellPBC	varchar(100)
	,UnbundledHRG	varchar(500)
	)
'
exec sp_executesql @command2
end

;begin
declare @command nvarchar(max)
set @command = '
BULK INSERT '+@tablename+'
	FROM '''+@path+'''
	WITH (RowTerminator = ''\n''
	,FieldTerminator = '',''
	, firstrow = 2
	)
	
select * from '+@tablename+''
--print @command
exec sp_executesql @command

END
end
;



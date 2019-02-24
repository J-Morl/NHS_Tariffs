use kubrick
go

if object_id('tariff.clean_17-18') is not null
begin
	drop table [tariff].[clean_17-18]
end
go

select --given -1000 to the null values to make it obvious they are not to be used
	[HRG code]
	, [HRG name]
	, convert(int, replace([Outpatient procedure tariff (£)], ',', '')) [Outpatient procedure tariff (£)]
	, isnull(convert(int, [Combined day case / ordinary elective spell tariff (£)]), -1000) [Combined day case / ordinary elective spell tariff (£)]
	, convert(int, replace([Day case spell tariff (£)], ',', '')) [Day case spell tariff (£)]
	, convert(int, replace([Ordinary elective spell tariff (£)], ',', '')) [Ordinary elective spell tariff (£)]
	, convert(int, [Ordinary elective long stay trim point (days)]) [Ordinary elective long stay trim point (days)]
	, convert(int, [Non-elective spell tariff (£)]) [Non-elective spell tariff (£)]
	, convert(int, [Non-elective long stay trim point (days)]) [Non-elective long stay trim point (days)]
	, convert(int, [Per day long stay payment (for days exceeding trim point) (£)])	[Per day long stay payment (for days exceeding trim point) (£)]
	, [Reduced short stay emergency tariff _applicable?]
	, isnull(convert(int, [Reduced short stay emergency tariff (£)]), -1000) [Reduced short stay emergency tariff (£)]
into tariff.[Clean_17-18]
from tariff.[hrg_17-18]

if object_id('tariff.clean_18-19') is not null
begin
	drop table [tariff].[clean_18-19]
end
go

select --given -1000 to the null values to make it obvious they are not to be used
	[HRG code]
	, [HRG name]
	, convert(int, replace([Outpatient procedure tariff (£)], ',', '')) [Outpatient procedure tariff (£)]
	, isnull(convert(int, [Combined day case / ordinary elective spell tariff (£)]), -1000) [Combined day case / ordinary elective spell tariff (£)]
	, convert(int, replace([Day case spell tariff (£)], ',', '')) [Day case spell tariff (£)]
	, convert(int, replace([Ordinary elective spell tariff (£)], ',', '')) [Ordinary elective spell tariff (£)]
	, convert(int, [Ordinary elective long stay trim point (days)]) [Ordinary elective long stay trim point (days)]
	, convert(int, [Non-elective spell tariff (£)]) [Non-elective spell tariff (£)]
	, convert(int, [Non-elective long stay trim point (days)]) [Non-elective long stay trim point (days)]
	, convert(int, [Per day long stay payment (for days exceeding trim point) (£)])	[Per day long stay payment (for days exceeding trim point) (£)]
	, [Reduced short stay emergency tariff _applicable?]
	, isnull(convert(int, [Reduced short stay emergency tariff (£)]), -1000) [Reduced short stay emergency tariff (£)]
into tariff.[Clean_18-19]
from tariff.[hrg_18-19]
go
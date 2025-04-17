--CREATED BY ANIRUDDHA ANIL SHINGARE--




select location,date,total_cases,new_cases,total_deaths,population
from [SQL project 1 Covid].[dbo].[Covid_Death]

--Total Cases Vs Total Deaths

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as death_percentage
from [SQL project 1 Covid].[dbo].[Covid_Death]
where continent is not null
and location = 'India' 
order by 1,2

-- Total cases Vs Total Population

select location,date,total_cases,population,(total_cases/population)*100 as case_percentage
from [SQL project 1 Covid].[dbo].[Covid_Death]
where location = 'India'
order by 1,2

--country wise total no of deaths--

select location,continent,population,max(total_deaths) as total_deaths
from [SQL project 1 Covid].[dbo].[Covid_Death]
group by location,continent,population
having continent is not null
order by 4 


--countrry with highest infection rate

select location,population,max(total_cases) as Total_Cases,max(total_cases/population)*100 as Highest_infection_rate
from [SQL project 1 Covid].[dbo].[Covid_Death]
group by location,population
order by Highest_infection_rate desc

--country with highest Death Rate

select location,population,max(total_deaths) as total_death,max(total_deaths/population)*100 as Highest_death_rate
from [SQL project 1 Covid].[dbo].[Covid_Death]
where continent <> 'null'
group by location,population
order by Highest_death_rate desc

--Brekdown based on continent--

--Total_Cases Vs Total_Deaths

with country_wise as (select location,continent,max(cast(total_cases as int)) as total_cases,max(cast(total_deaths as int)) as total_deaths
from [SQL project 1 Covid].[dbo].[Covid_Death]
group by location,continent
having continent is not null)
select continent,sum(total_cases) as all_cases,sum(total_deaths) as all_deaths
from country_wise
group by continent
order by 3 desc


select continent,sum(cast(new_cases as int)) as total_cases ,sum(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as death_percentage
from [SQL project 1 Covid].[dbo].[Covid_Death]
group by continent
having continent is not null
order by 3 desc


--by Date

select date,sum(cast(new_cases as int)) as total_cases ,sum(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as death_percentage
from [SQL project 1 Covid].[dbo].[Covid_Death]
where continent is not null
group by date
order by 1,2

----vaccines

--Total Population of a country Vs Total Vaccinations

select cv.continent,cv.location,cv.date,cd.population,cv.new_vaccinations,
sum(convert(int,cv.new_vaccinations))over(partition by cv.location order by cv.location,cv.date) as total_people_vaccinated
from [SQL project 1 Covid].[dbo].[Covid_Death] cd
join [SQL project 1 Covid].[dbo].[Covid_Vaccins] cv 
on cd.location = cv.location and cd.date = cv.date
where cv.continent is not null
order by 2,3

--Percentage of population vaccianted for each country

with popVsvac as (select cv.continent,cv.location,cv.date,cd.population,cv.new_vaccinations,
sum(convert(int,cv.new_vaccinations))over(partition by cv.location order by cv.location,cv.date) as total_people_vaccinated
from [SQL project 1 Covid].[dbo].[Covid_Death] cd
join [SQL project 1 Covid].[dbo].[Covid_Vaccins] cv 
on cd.location = cv.location and cd.date = cv.date
where cv.continent is not null)
select *,(total_people_vaccinated/population)*100 as percentage_of_population_vaccinated
from popVsvac
order by 2,3


---creating Views for visualization

--TotalPeopleVaccinated Vs Population (Country wise)

create view TotalPeopleVaccinated as 
select cv.continent,cv.location,cv.date,cd.population,cv.new_vaccinations,
sum(convert(int,cv.new_vaccinations))over(partition by cv.location order by cv.location,cv.date) as total_people_vaccinated
from [SQL project 1 Covid].[dbo].[Covid_Death] cd
join [SQL project 1 Covid].[dbo].[Covid_Vaccins] cv 
on cd.location = cv.location and cd.date = cv.date
where cv.continent is not null
--order by 2,3 




--Total_cases Vs Total_deaths (Continent wise)--

create view ContinentTotalcasesVsTotaldeaths as 
select continent,sum(cast(new_cases as int)) as total_cases ,sum(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as death_percentage
from [SQL project 1 Covid].[dbo].[Covid_Death]
group by continent
having continent is not null
--order by 3 desc

--Total_cases Vs Total_deaths Vs Percentage (Global)--
with continent_wise as (
select sum(cast(new_cases as int)) as total_cases ,sum(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as death_percentage
from [SQL project 1 Covid].[dbo].[Covid_Death]
where continent is not null)
select sum(total_cases) as total_cases_globally,sum(total_deaths) as total_deaths_globally,avg(death_percentage) as avg_global_death_percentage
from continent_wise


--Country Vs Total Deaths--

create view CountryVsNo_of_deaths as
select location,continent,population,sum(cast(new_deaths as int)) as total_deaths
from [SQL project 1 Covid].[dbo].[Covid_Death]
group by location,continent,population
having continent is not null
--order by 4 desc


--country Vs Infection Rate--

create view CountryVsInfectionRate as
select location,population,sum(cast(new_cases as int)) as Total_Cases,max(total_cases/population)*100 as Highest_infection_rate
from [SQL project 1 Covid].[dbo].[Covid_Death]
group by location,population
order by Highest_infection_rate desc

--country Vs Death Rate--

create view CountryVsDeathRate as
select location,population,sum(cast(new_deaths as int)) as total_death,max(total_deaths/population)*100 as Highest_death_rate
from [SQL project 1 Covid].[dbo].[Covid_Death]
where continent <> 'null'
group by location,population
--order by Highest_death_rate desc



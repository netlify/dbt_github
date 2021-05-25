with repository as (
    select *
    from {{ ref('stg_github_repository')}}
),

repo_teams as (
    select *
    from {{ ref('stg_github_repo_team')}}
),

teams as (
    select *
    from {{ ref('stg_github_team')}}
),

team_repo as (
    select
        repository.repository_id,
        repository.full_name as repository,
        teams.name as team_name
    from repository

    left join repo_teams
        on repository.repository_id = repo_teams.repository_id

    left join teams
        on repo_teams.team_id = teams.team_id
),

final as (
    select
        repository_id,
        repository,
        {{ fivetran_utils.string_agg('team_name', "', '" ) }} as repository_team_names
    from team_repo

    group by 1, 2
)

select *
from final

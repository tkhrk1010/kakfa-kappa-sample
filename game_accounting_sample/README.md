# game accounting sample

```mermaid  
stateDiagram
    [*] --> 利用前: 利用申請
    利用前 --> 利用後: 利用
    利用前 --> キャンセル: 利用前キャンセル
    利用後 --> キャンセル: 利用後キャンセル
```
## quick start
```
$ make start
$ make monitor
# in other terminal
$ make test
```
You can see the result with sql below:
```sql
select
	ga.id
	, ga.user_id
	, ga.applied_at
	, gu.used_at
	, gcbu.canceled_at before_cancel_at
	, gcau.canceled_at after_cancel_at
	, *
from
	game_application ga
	left join game_usage gu on ga.id = gu.game_application_id
	left join game_cancel_before_use gcbu on gcbu.game_application_id = ga.id
	left join game_cancel_after_use gcau on gcau.game_application_id = ga.id
;
```
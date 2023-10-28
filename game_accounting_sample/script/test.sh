#!/bin/bash

# stdout all log 
set -x

# chmod +x script/test.sh

#
# case 1: apply game and use. after that, user realise it is mistake, then cancel.
#
# apply game
./script/send_message.sh 1

sleep 10

# get game_application_id
GAME_APPLICATION_ID_1=$(docker exec -i game_accounting_sample-postgres-1 psql -U db_user -d game_db -t -c "select ga.id from game_application ga left join game_usage gu on ga.id = gu.game_application_id where gu.id is null order by ga.applied_at desc limit 1;" | tr -d '[:space:]')

# use game
./script/send_message.sh 2 $GAME_APPLICATION_ID_1

# cancel game
./script/send_message.sh 3 $GAME_APPLICATION_ID_1


#
# case 2: apply game and cancel before use
#
# apply game
./script/send_message.sh 1

sleep 10

# get game_application_id
GAME_APPLICATION_ID_2=$(docker exec -i game_accounting_sample-postgres-1 psql -U db_user -d game_db -t -c "select ga.id from game_application ga left join game_usage gu on ga.id = gu.game_application_id where gu.id is null order by ga.applied_at desc limit 1;" | tr -d '[:space:]')

# cancel game
./script/send_message.sh 3 $GAME_APPLICATION_ID_2
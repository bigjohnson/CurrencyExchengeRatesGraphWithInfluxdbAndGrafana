#!/bin/bash
ALL=$(curl -s "https://api.frankfurter.dev/v2/rates?quotes=BRL,USD,CHF,GBP" )
#echo ${ALL}
BRL=$(echo ${ALL} | jq '.[0]'.rate)
#echo BRL ${BRL}
IBRL=$(echo "scale=6;1.0 / ${BRL}" | bc)
#echo IBRL ${IBRL}
USD=$(echo ${ALL} | jq '.[1]'.rate)
#echo USD ${USD}
IUSD=$(echo "scale=6;1.0 / ${USD}" | bc)
#echo IUSD ${IUSD}
GBP=$(echo ${ALL} | jq '.[3]'.rate)
#echo GBP ${GBP}
IGBP=$(echo "scale=6;1.0 / ${GBP}" | bc)
#echo IGPB ${IGBP}
CHF=$(echo ${ALL} | jq '.[2]'.rate)
#echo CHF ${CHF}
ICHF=$(echo "scale=6;1.0 / ${CHF}" | bc)
#echo ICHF ${ICHF}
curl -i -u INFLUXDBUSER:INFLUXDBPASSWORD --silent --output /dev/null -XPOST 'http://IOURINFLUXDBSERVER:8086/write?db=grafana' --data-binary "exchange_rate,country=BRL,type=direct value=${BRL}
exchange_rate,country=BRL,type=inverse value=${IBRL}
exchange_rate,country=USD,type=direct value=${USD}
exchange_rate,country=USD,type=inverse value=${IUSD}
exchange_rate,country=GBP,type=direct value=${GBP}
exchange_rate,country=GBP,type=inverse value=${IGBP}
exchange_rate,country=CHF,type=direct value=${CHF}
exchange_rate,country=CHF,type=inverse value=${ICHF}"

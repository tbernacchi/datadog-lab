kubectl run curl -n apm-apps --image=curlimages/curl:latest -it --rm --command -- sh

curl -X POST http://dotnet-todoapi.apm-apps.svc.cluster.local:8081/api/todoitems -H 'Content-Type:application/json' -d '{"name":"Tarefa para deletar","isComplete":false}'
curl -X POST http://dotnet-todoapi.apm-apps.svc.cluster.local:8081/api/todoitems -H 'Content-Type:application/json' -d '{"name":"Instrumentar aplicação","isComplete":false}'
curl -X POST http://dotnet-todoapi.apm-apps.svc.cluster.local:8081/api/todoitems -H 'Content-Type:application/json' -d '{"name":"Configurar Unified Service Tagging","isComplete":false}'
curl -X POST http://dotnet-todoapi.apm-apps.svc.cluster.local:8081/api/todoitems -H 'Content-Type:application/json' -d '{"name":"Habilitar Runtime Metrics","isComplete":false}'
curl -X GET http://dotnet-todoapi.apm-apps.svc.cluster.local:8081/api/todoitems -H 'Content-Type:application/json'
curl -X PUT http://dotnet-todoapi.apm-apps.svc.cluster.local:8081/api/todoitems -H 'Content-Type:application/json' -d '{"name":"Instrumentar aplicação","isComplete":true}'
curl -X DELETE http://dotnet-todoapi.apm-apps.svc.cluster.local:8081/api/todoitems/1 -H 'Content-Type:application/json'
curl -X GET http://dotnet-todoapi.apm-apps.svc.cluster.local:8081/api/todoitems -H 'Content-Type:application/json'

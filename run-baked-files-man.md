Для запуска собранных (запеченных) файлов, следует предварительным этапом выполнить следующую команду:  


```
find PATH -type f -name "*.js" \
-exec sed -i 's#||WIDGET_PLATFORM_API_URL_PLACEHOLDER||#widget_platform_api_url_placeholder#g' {} \; \
-exec sed -i 's#||GRAPHQL_DATA_API_URL_PLACEHOLDER||#graphql_data_api_url_placeholder#g' {} \; \
-exec sed -i 's#||FEEDBACK_API_URL_PLACEHOLDER||#feedback_api_url_placeholder#g' {} \; \
-exec sed -i 's#||SUBSCRIBE_API_URL_PLACEHOLDER||#subscribe_api_url_placeholder"'#g' {} \; ;
```


Где:  
`PATH` - путь, где физически расположены собранные файлы;  
`widget_platform_api_url_placeholder` - адрес api-виджетной платформы, например: `http://wp-api.demositerus.test`;  
`graphql_data_api_url_placeholder` - адрес эндпоинта плагина для QP реализующего логику GraphQL, например: `http://graphql.demositerus.test/graphql` (важно, адрес должен указывать на конкретный эндпоинт для приема запросов, т.е. `/graphql`);  
`feedback_api_url_placeholder` - часть адреса эндпоинта api-фидбека, например: `feedback/sendfeedback`;  
`subscribe_api_url_placeholder` - часть адреса эндпоинта api-подписки, например: `subscribe/add`.  


Данная команда уже интегрирована в готовый образ-докера, для корректной работы достаточно лишь запустить образ передав ему необходимые переменные среды. Пример такого запуска (IMAGE - следует заменить на актуальную версию образа):  


`docker run -p 4000:4000 -d -e GRAPHQL_DATA_API_URL_PLACEHOLDER=http://graphql.demositerus.test/graphql -e WIDGET_PLATFORM_API_URL_PLACEHOLDER=http://wp-api.demositerus.test -e FEEDBACK_API_URL_PLACEHOLDER=feedback/sendfeedback -e SUBSCRIBE_API_URL_PLACEHOLDER=subscribe/add IMAGE`  

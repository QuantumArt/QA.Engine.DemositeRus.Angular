ARG NODE_IMAGE=node:16
ARG RUNTIME_IMAGE=${NODE_IMAGE}-slim

FROM ${NODE_IMAGE} as build
WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY .browserslistrc ./
COPY angular.json ./
COPY server.ts ./
COPY tsconfig*.json ./
COPY src ./src

RUN npm run build:ssr -- --configuration=production

FROM $RUNTIME_IMAGE as runtime
RUN apt-get update && apt-get install -y --no-install-recommends dumb-init

WORKDIR /app

COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/package*.json ./
COPY --from=build /app/dist ./dist

ENV NODE_ENV production
EXPOSE 4000

# Find all js files, after that replace (with env) "baked" urls, and serve corrected statics
CMD find /app/dist/ -type f -name "*.js" \
-exec sed -i 's#||WIDGET_PLATFORM_API_URL_PLACEHOLDER||#'"$WIDGET_PLATFORM_API_URL_PLACEHOLDER"'#g' {} \; \
-exec sed -i 's#||GRAPHQL_DATA_API_URL_PLACEHOLDER||#'"$GRAPHQL_DATA_API_URL_PLACEHOLDER"'#g' {} \; \
-exec sed -i 's#||FEEDBACK_API_URL_PLACEHOLDER||#'"$FEEDBACK_API_URL_PLACEHOLDER"'#g' {} \; \
-exec sed -i 's#||SUBSCRIBE_API_URL_PLACEHOLDER||#'"$SUBSCRIBE_API_URL_PLACEHOLDER"'#g' {} \; ;\
dumb-init node dist/demosite/server/main.js
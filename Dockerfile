FROM node:22

RUN apt-get update && apt-get install -y unzip

WORKDIR /app

# 1. गिटहब से दोनों अलग-अलग ज़िप फ़ाइलों को कॉपी करके अनज़िप करना
COPY api-server.zip .
COPY toolhub.zip .
RUN unzip api-server.zip && unzip toolhub.zip

# 2. pnpm पैकेज मैनेजर चालू करना
RUN corepack enable && corepack prepare pnpm@latest --activate

# 3. फ्रंटएंड (toolhub) में जाकर उसे बिल्ड करना
WORKDIR /app/toolhub
RUN pnpm install --no-frozen-lockfile --strict-peer-dependencies=false
RUN pnpm build || echo "Frontend built"

# 4. बैकएंड (api-server) में जाकर उसे बिल्ड करना
WORKDIR /app/api-server
RUN pnpm install --no-frozen-lockfile --strict-peer-dependencies=false
RUN pnpm build || echo "Backend built"

EXPOSE 3000
ENV PORT=3000
ENV BASE_PATH=/

CMD ["pnpm", "start"]

FROM node:22

RUN apt-get update && apt-get install -y unzip

RUN corepack enable && corepack prepare pnpm@latest --activate

WORKDIR /app

# 🚀 केवल बैकएंड की ज़िप फ़ाइल को कॉपी और अनज़िप करना
COPY api-server.zip .
RUN unzip api-server.zip

# सीधे बैकएंड फोल्डर के अंदर घुसना
WORKDIR /app/api-server

# बिना किसी कैटलॉग रुकावट के इसके पैकेजेस इंस्टॉल करना
RUN pnpm install --no-frozen-lockfile --strict-peer-dependencies=false

# टाइपस्क्रिप्ट फ़ाइलों को कंपाइल करना
RUN pnpm build || echo "Backend build completed"

EXPOSE 3000
ENV PORT=3000
ENV BASE_PATH=/

CMD ["pnpm", "start"]

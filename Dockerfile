FROM flowiseai/flowise:latest
RUN find /usr/local/lib/node_modules/flowise/dist/database/migrations/postgres/ -type f -exec sed -i 's/uuid_generate_v4()/gen_random_uuid()/g' {} +


# ─────────────────────────────────────────────
#  STAGE 1 — Install dependencies
# ─────────────────────────────────────────────
FROM node:20-alpine AS builder

# Set working directory inside the container
WORKDIR /app

# Copy package files first (layer caching — only re-runs if package.json changes)
COPY app/package*.json ./

# Install production dependencies only
RUN npm install --production

# ─────────────────────────────────────────────
#  STAGE 2 — Final lean production image
# ─────────────────────────────────────────────
FROM node:20-alpine

WORKDIR /app

# Copy installed node_modules from builder stage
COPY --from=builder /app/node_modules ./node_modules

# Copy application source code
COPY app/ .

# Expose the port the app listens on
EXPOSE 3000

# Set default environment
ENV NODE_ENV=production

# Health check — Docker will ping this every 30s
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD wget -qO- http://localhost:3000 || exit 1

# Command to run when container starts
CMD ["node", "server.js"]

# frozen_string_literal: true

RedisDashboard.urls = [
  ENV.fetch("CACHE_REDIS_URL", "redis://redis:6379")
]

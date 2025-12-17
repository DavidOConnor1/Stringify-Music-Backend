# bin/predeploy
echo "🚀 Pre-deployment checks..."

echo "1. Running tests..."
rails test || { echo "Tests failed!"; exit 1; }

echo "2. Checking production configuration..."
RAILS_ENV=production rails runner "puts '✓ Production config OK'" || { echo "Production config error!"; exit 1; }

echo "3. Checking database..."
rails db:migrate:status || { echo "Database error!"; exit 1; }

echo "4. Precompiling assets..."
RAILS_ENV=production rails assets:precompile || { echo "Asset precompilation failed!"; exit 1; }

echo "✅ All checks passed! Ready for deployment."
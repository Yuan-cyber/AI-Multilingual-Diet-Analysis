#!/bin/bash

echo "AI Diet Analysis - Core Tests"
echo "================================="

echo "Testing backend..."
cd backend

if ruby spec/core_test.rb; then
  echo ""
  echo "✅ Core functionality verified!"
  echo "Ready for demo!"
else
  echo ""
  echo "❌ Tests failed!"
  exit 1
fi 
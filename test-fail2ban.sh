#!/bin/bash

# Fail2Ban Apache brute force test script

echo "Simulating brute-force login attempts to /secure/..."

for i in {1..6}; do
  echo "Attempt $i..."
  curl -u testuser:wrongpass http://localhost/secure/ > /dev/null 2>&1
  sleep 1
done

echo "Done. Check Fail2Ban status:"
echo "  sudo fail2ban-client status apache-auth"

fail2ban-client status | sed -n 's/,//g;s/.*Jail list://p' | xargs -n1 fail2ban-client status

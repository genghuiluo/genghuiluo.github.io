---
layout: post
title: expect script sample
date: 2017-05-21 19:34:31 +0800
categories: linux
---
> Expect scripting language is used to feed input automatically to an interactive program.
[wiki](http://www.thegeekstuff.com/2010/10/expect-examples)

### ssh login with expect
``` bash
ssh -i ~/.ssh/id_rsa_erhuang_core01 dw_dev@gauls.vip.ebay.com "cd $GAULS_DIR; expect <<EOF
spawn sftp ${SFTP_OPT} ${sftp_user}@${sftp_host}
expect {
        \"*assword:\" {
            send \"${sftp_passwd}\\r\"
            expect {
                timeout {send_user \"Can't connect to remote sftp\"; exit 1}
                \"*denied*\" {send_user \"SFTP auth failed\"; exit 1}
                \"sftp>\"
            }
        }
        \"sftp>\"
}
send \"put $TGT_FILE ${sftp_path}/ \\r\"
expect {
    \"*No such file or directory*\" {send_user \"No such file or directory\"; exit 1}
    \"sftp>\"
}
send \"exit\\r\"
EOF"
```

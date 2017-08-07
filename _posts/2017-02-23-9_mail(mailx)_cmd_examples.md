---
layout: post
title: 9 mail(mailx) cmd examples
date: 2017-02-23 17:19:22 +0800
categories: linux
---
### How does it work?

The mail/mailx command needs a local smtp server (MTA) running in order to deliver the emails. THe route taken by the email is somewhat like this:
```
mail -> sendmail -> local MTA -> recipient MTA [Inbox]
```
The recipient MTA would be gmail's smtp server if your recipient is someone at gmail.com for instance. For the local MTA, you need to install an smtp server like Postfix. A basic installation of Postfix with minimal configuration would work in most cases.

#### Install the mailx command

On Ubuntu/Debian based systems the mailx command is available from 2 different packages -

1. [heirloom-mailx](http://heirloom.sourceforge.net/mailx.html)
2. bsd-mailx

We shall be using the heirloom-mailx package because it has more features and options.
On CentOS/Fedora based systems, there is only one package named "mailx" which is the heirloom package.

To find out what mailx package is installed on your system, check the "man mailx" output and scroll down to the end and you should see some useful information.
```
# ubuntu/debian
$ sudo apt-get install heirloom-mailx

# fedora/centos
$ sudo yum install mailx
```

### Using the mailx command

Once installed, the mailx command can be directly referenced with the name mail, so you just type in that in the command line.

#### 1. Simple mail
Run the following command, and then mailx would wait for you to enter the message of the email. You can hit enter for new lines. When done typing the message, press Ctrl+D and mailx would display EOT.

After than mailx automatically delivers the email to the destination.
```
$ mail -s "This is the subject" someone@example.com
Hi someone
How are you
I am fine
Bye
EOT
```

#### 2. Take message from a file
The message body of the email can be taken from a file as well.

`$ mail -s "This is Subject" someone@example.com < /path/to/file`

The message can also be piped using the echo command -

`$ echo "This is message body" | mail -s "This is Subject" someone@example.com`

#### 3. Multiple recipients
To send the mail to multiple recipients, specify all the emails separated by a comma

`$ echo "This is message body" | mail -s "This is Subject" someone@example.com,someone2@example.com`

#### 4. CC and BCC
The "-c" and "-b" options can be used to add CC and BCC addresses respectively.

`$ echo "This is message body" | mail -s "This is Subject" -c ccuser@example.com someone@example.com`

#### 5. Specify From name and address
To specify a "FROM" name and address, use the "-r" option. The name should be followed by the address wrapped in "<>".

`$ echo "This is message body" | mail -s "This is Subject" -r "Harry<harry@gmail.com>" someone@example.com`

#### 6. Specify "Reply-To" address
The reply to address is set with the internal option variable "replyto" using the "-S" option.
```
# replyto email
$ echo "This is message" | mail -s "Testing replyto" -S replyto="mark@gmail.com" someone@example.com

# replyto email with a name
$ echo "This is message" | mail -s "Testing replyto" -S replyto="Mark<mark@gmail.com>" someone@example.com
```

#### 7. Attachments
Attachments can be added with the "-a" option.

`$ echo "This is message body" | mail -s "This is Subject" -r "Harry<harry@gmail.com>" -a /path/to/file someone@example.comi`

#### 8. Use external SMTP server
This is an exclusive feature, that you get only with heirloom mailx and not bsd mailx, or the mail command from gnu mailutils or the mutt command.

The mailx command can use an external smtp server to use to relay the message forward. The syntax is a bit lengthy but makes sense.
```
$ echo "This is the message body and contains the message" | mailx -v -r "someone@example.com" -s "This is the subject" -S smtp="mail.example.com:587" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="someone@example.com" -S smtp-auth-password="abc123" -S ssl-verify=ignore yourfriend@gmail.com
```

Here is a breakdown
```
$ echo "This is the message body and contains the message" | mailx -v \
> -r "someone@example.com" \
> -s "This is the subject" \
> -S smtp="mail.example.com:587" \
> -S smtp-use-starttls \
> -S smtp-auth=login \
> -S smtp-auth-user="someone@example.com" \
> -S smtp-auth-password="abc123" \
> -S ssl-verify=ignore \
> yourfriend@gmail.com
```
You can use the gmail smtp servers and send emails via your gmail account. That is so cool!
For gmail specifically you would need to enable [less secure apps settings](https://www.google.com/settings/security/lesssecureapps) before you can send mail like that.

#### 9. Verbose - watch smtp communication
When using external smtp servers, you can choose to watch the entire smtp communication that is done in the background. This is useful specially when testing or debugging smtp servers.
```
$ echo "This is the message body and contains the message from heirloom mailx" | mailx -v -s "This is the subject" -S smtp="smtp.gmail.com:587" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="mygmail@gmail.com" -S smtp-auth-password="mypassword" -S ssl-verify=ignore someone@example.com
Resolving host smtp.gmail.com . . . done.
Connecting to 74.125.68.109:587 . . . connected.
220 mx.google.com ESMTP je4sm32812877pbd.94 - gsmtp
>>> EHLO enlightened
250-mx.google.com at your service, [122.163.43.21]
250-SIZE 35882577
250-8BITMIME
250-STARTTLS
250-ENHANCEDSTATUSCODES
250-PIPELINING
250-CHUNKING
250 SMTPUTF8
>>> STARTTLS
220 2.0.0 Ready to start TLS
>>> EHLO enlightened
250-mx.google.com at your service, [122.163.43.21]
250-SIZE 35882577
250-8BITMIME
250-AUTH LOGIN PLAIN XOAUTH XOAUTH2 PLAIN-CLIENTTOKEN OAUTHBEARER
250-ENHANCEDSTATUSCODES
250-PIPELINING
250-CHUNKING
250 SMTPUTF8
>>> AUTH LOGIN
334 VXNlcm5hbWU6
>>> Ymx1ZWJ1enppdEBnbWFpbC5jb20=
334 UGFzc3dvcmQ6
>>> KnJpc2hhYmgzKg==
235 2.7.0 Accepted
>>> MAIL FROM:<enlightened@enlightened>
250 2.1.0 OK je4sm32812877pbd.94 - gsmtp
>>> RCPT TO:<someone@example.com>
250 2.1.5 OK je4sm32812877pbd.94 - gsmtp
>>> DATA
354  Go ahead je4sm32812877pbd.94 - gsmtp
>>> .
250 2.0.0 OK 1417930703 je4sm32812877pbd.94 - gsmtp
>>> QUIT
221 2.0.0 closing connection je4sm32812877pbd.94 - gsmtp
```

### Troubleshooting

In case the mails are not being delivered properly you need to check a few things. The first thing to check is that an smtp server (mta) is running locally. The netstat command can tell that
```
$ sudo netstat -ltnp | grep 25
[sudo] password for enlightened: 
tcp        0      0 0.0.0.0:25              0.0.0.0:*               LISTEN      2541/master     
tcp6       0      0 :::25                   :::*                    LISTEN      2541/master
```
If an stmp server like Postfix is running and still mails are not going, then try re-configuring Postfix for example. On Ubuntu/Debian systems, this can be done with the dpkg-reconfigure command
```
$ sudo dpkg-reconfigure postfix
```
Then retry, the mail command and it should work. If it still doesn't, try contacting your server provider.

**No mails from local systems**

If you try to send mails from your local computer to a gmail address, your mail would most likely be rejected, so don't try doing that.

This is because ordinary computers connected to internet address have an ip address that is not associated with any valid domain as such, and gmail strictly verifies such credentials before approving any mail to go through.

### Notes and Resources

Apart from mailx, there are other tools like Swaks and [smtp-cli](http://www.logix.cz/michal/devel/smtp-cli/) that can be used to send mails from command line and support various features like specifying smtp servers and adding attachments and so on.

However the mailx command is available in the default repositories of most common distros, so can be installed easily. Further it maintains a syntax very similar to that of the mail command which makes it a drop in replacement for the older mail command.

The mailx command is even capable of reading mails from remote IMAP servers, but that is something we kept out of this post and would talk later. To learn more check the man page for the mailx command with "man mailx".

{
  accounts = {
    calendar = {
    };
    email = {
      accounts = {
        ekstrom = {
          address = "joey@ekstrom.org";
          #gpg = {
          #  key = "F9119EC8FCC56192B5CF53A0BF4F64254BD8C8B5";
          #  signByDefault = true;
          #};
          imap.host = "mail.ekstrom.org";
          aerc = {
            enable = true;
            extraAccounts = {
              #source = "maildir://~/Maildir/ekstrom";
              #check-mail-cmd = "mbsync ekstrom";
              source = "notmuch://~/Maildir/";
              maildir-store = "~/Maildir";
              maildir-account-path = "ekstrom";
              check-mail-cmd = "mbsync ekstrom && notmuch new";
              check-mail-timeout = "90s";
              check-mail = "5m";
            };
          };
          mbsync = {
            enable = true;
            create = "maildir";
          };
          msmtp.enable = true;
          neomutt = {
            enable = true;
          };
          notmuch.enable = true;
          primary = true;
          realName = "Joey Ekstrom";
          signature = {
            text = ''
              -Joey
            '';
            showSignature = "append";
          };
          passwordCommand = "bw get password af0b0524-c372-424b-b7f3-b0b800fc5174";
          smtp = {
            host = "mail.ekstrom.org";
          };
          userName = "joey@ekstrom.org";
        };
        ekstech = {
          address = "joey@ekstech.net";
          #gpg = {
          #  key = "F9119EC8FCC56192B5CF53A0BF4F64254BD8C8B5";
          #  signByDefault = true;
          #};
          imap.host = "moose.mxrouting.net";
          aerc = {
            enable = true;
            extraAccounts = {
              #source = "maildir://~/Maildir/ekstech";
              #check-mail-cmd = "mbsync ekstech";
              source = "notmuch://~/Maildir/";
              maildir-store = "~/Maildir";
              maildir-account-path = "ekstech";
              check-mail-cmd = "mbsync ekstech && notmuch new";
              check-mail-timeout = "90s";
              check-mail = "5m";
            };
          };
          mbsync = {
            enable = true;
            create = "maildir";
          };
          msmtp.enable = true;
          neomutt = {
            enable = true;
          };
          notmuch.enable = true;
          realName = "Joey Ekstrom";
          signature = {
            text = ''
              -Joey Ekstrom
            '';
            showSignature = "append";
          };
          passwordCommand = "bw get password 77f82336-9c67-47a4-b7d3-ae2d01307340";
          smtp = {
            host = "moose.mxrouting.net";
          };
          userName = "joey@ekstech.net";
        };
        rcmtb = {
          address = "joey@rcmtb.org";
          #gpg = {
          #  key = "F9119EC8FCC56192B5CF53A0BF4F64254BD8C8B5";
          #  signByDefault = true;
          #};
          imap.host = "moose.mxrouting.net";
          aerc = {
            enable = true;
            extraAccounts = {
              #source = "maildir://~/Maildir/rcmtb";
              #check-mail-cmd = "mbsync rcmtb";
              source = "notmuch://~/Maildir/";
              maildir-store = "~/Maildir";
              maildir-account-path = "rcmtb";
              check-mail-cmd = "mbsync rcmtb && notmuch new";
              check-mail-timeout = "90s";
              check-mail = "5m";
            };
          };
          mbsync = {
            enable = true;
            create = "maildir";
          };
          msmtp.enable = true;
          neomutt = {
            enable = true;
          };
          notmuch.enable = true;
          realName = "Joey Ekstrom";
          signature = {
            text = ''
              -Joey
            '';
            showSignature = "append";
          };
          passwordCommand = "bw get password 58096753-9c17-44c8-92cd-aeb500036755";
          smtp = {
            host = "moose.mxrouting.net";
          };
          userName = "joey@rockcreekmtb.org";
        };
        sablerock = {
          address = "sablerock@ekstech.net";
          #gpg = {
          #  key = "F9119EC8FCC56192B5CF53A0BF4F64254BD8C8B5";
          #  signByDefault = true;
          #};
          imap.host = "moose.mxrouting.net";
          aerc = {
            enable = true;
            extraAccounts = {
              #source = "maildir://~/Maildir/sablerock";
              #check-mail-cmd = "mbsync sablerock";
              source = "notmuch://~/Maildir";
              maildir-store = "~/Maildir";
              maildir-account-path = "sablerock";
              check-mail-cmd = "mbsync sablerock && notmuch new";
              check-mail-timeout = "90s";
              check-mail = "5m";
            };
          };
          mbsync = {
            enable = true;
            create = "maildir";
          };
          msmtp.enable = true;
          neomutt = {
            enable = true;
          };
          notmuch = {
            enable = true;
            neomutt.enable = true;
          };
          realName = "Joey Ekstrom";
          signature = {
            text = ''
              -Joey
            '';
            showSignature = "append";
          };
          passwordCommand = "bw get password 8b527369-ef83-4ef0-b5bc-afcd0136f1ac";
          smtp = {
            host = "moose.mxrouting.net";
          };
          userName = "sablerock@ekstech.net";
        };
      };
    };
  };
}

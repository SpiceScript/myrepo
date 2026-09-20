# 🚀 Importing a Large MySQL Database Backup to Hostinger via SSH (Windows)

This guide explains how to upload and import a large MySQL `.sql.gz` backup into Hostinger when phpMyAdmin cannot handle big files. It uses **Windows PowerShell + SSH** and works for backups up to several GB in size.

---

## 🔹 Prerequisites
- **Hostinger account** with:
  - SSH access enabled  
  - A database already created (`DB Name`, `DB User`, and password)  
- **Windows 10/11** with PowerShell (default installed)  
- Your `.sql.gz` backup file on your PC. Example:  
  ```
  C:\Users\YourUsername\Downloads\wordpress_backup.sql.gz
  ```

---

## 🔹 Step 1: Connect to Hostinger via SSH
Open PowerShell and run:

```powershell
ssh -p SSH_PORT your_ssh_username@your_hostinger_server_ip
```

Example:
```powershell
ssh -p 65002 username@yourdomain.com
```
<img width="555" height="245" alt="image" src="https://github.com/user-attachments/assets/b72ce85f-5bf0-45d3-ba25-320a818f840a" />

Exit back to PowerShell at any time:
```bash
exit
```

---

## 🔹 Step 2: Upload the SQL backup
Run this **in PowerShell (local machine, not SSH)**:

```powershell
scp -P SSH_PORT "C:\Users\YourUsername\Downloads\wordpress_backup.sql.gz" your_ssh_username@your_hostinger_server_ip:~
```

Enter your **SSH password** when prompted. This uploads the `.sql.gz` file to your Hostinger home folder.

---

## 🔹 Step 3: Reconnect and confirm upload
```powershell
ssh -p SSH_PORT your_ssh_username@your_hostinger_server_ip
```

Inside SSH, list files:
```bash
ls -lh
```

You should see your `.sql.gz` file.

---

## 🔹 Step 4: Extract the SQL file
```bash
gunzip wordpress_backup.sql.gz
```

Now you’ll have:
```
wordpress_backup.sql
```

---

## 🔹 Step 5: Import into MySQL
Run:
```bash
mysql -u your_db_user -p your_db_name < wordpress_backup.sql
```

Example:
```bash
mysql -u db_user -p db_name < wordpress_backup.sql
```

Enter your **MySQL database password** (not SSH password). The import may take a few minutes depending on file size.

---

## 🔹 Step 6: Verify import
Log into MySQL:
```bash
mysql -u your_db_user -p your_db_name
```

Then check tables:
```sql
SHOW TABLES;
```

You should see WordPress tables like:
```
wp_posts
wp_users
wp_options
...
```

Exit MySQL:
```sql
exit;
```

---

## 🔹 Step 7: Fix WordPress site URL (if needed)
If your WordPress site doesn’t load, reset the URL inside MySQL:

```sql
UPDATE wp_options SET option_value='https://yourdomain.com' WHERE option_name='siteurl' OR option_name='home';
```

---

## 🔹 Troubleshooting
- **`character_set_client` NULL error** → Happens if you split SQL incorrectly. Always import the full `.sql` file.  
- **Access denied for user** → Check that you used the correct **DB user/password** from Hostinger hPanel.  
- **File too large** → Always upload via `scp`, not phpMyAdmin.  

---

## ✅ Done!
Your WordPress database is now restored successfully on Hostinger 🚀

---

### 🔗 References
- [Hostinger SSH Access](https://support.hostinger.com/en/articles/1583240-how-to-connect-to-your-account-using-ssh)
- [MySQL Import Docs](https://dev.mysql.com/doc/refman/8.0/en/importing-mysql-dump-files.html)


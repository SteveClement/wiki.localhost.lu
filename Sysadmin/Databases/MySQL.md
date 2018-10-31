# How to reset the root password for MySQL

1. Stop your current MySQL database if it is running

2. Start MySQL in safe mode and bypass reading the privilege table.

```bash
root@myserver# mysqld_safe --skip-grant-tables
```

3. Reset your root password MySQL console.

```bash
root@myserver# mysql -u root mysql
```

```
mysql> update user set Password=PASSWORD('new-password');
mysql> flush privileges;
mysql exit;
```

4. Kill the MySQL process and restart MySQL normally.

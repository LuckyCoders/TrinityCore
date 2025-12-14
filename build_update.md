# Инструкция по адаптации сервера к новой версии клиента

## Обзор

Данная инструкция описывает процесс обновления сервера TrinityCore для поддержки новой версии клиента World of Warcraft. Процесс включает обновление базы данных auth и создание SQL-скриптов миграции.

## Шаги обновления

### 1. Определение новой версии

Узнайте номер новой версии билда клиента. Формат версии: `X.Y.Z.BUILD` (например, `11.2.5.64502`).

### 2. Получение ключей аутентификации

Для новой версии необходимо получить ключи аутентификации (`build_auth_key`) для всех поддерживаемых платформ:
- **Mac**: A64 (ARM64), x64
- **Windows**: A64 (ARM64), x64
- **Типы клиентов**: WoW (Retail), WoWC (Retail China)

Ключи обычно предоставляются сообществом или извлекаются из клиента.

### 3. Обновление файла `sql/base/auth_database.sql`

#### 3.1. Добавление ключей аутентификации в таблицу `build_auth_key`

Найдите секцию `INSERT INTO \`build_auth_key\`` (примерно строка 1340) и добавьте новые записи перед закрывающей скобкой:

```sql
(NEW_BUILD,'Mac','A64','WoW',0x...),
(NEW_BUILD,'Mac','A64','WoWC',0x...),
(NEW_BUILD,'Mac','x64','WoW',0x...),
(NEW_BUILD,'Mac','x64','WoWC',0x...),
(NEW_BUILD,'Win','A64','WoW',0x...),
(NEW_BUILD,'Win','x64','WoW',0x...),
(NEW_BUILD,'Win','x64','WoWC',0x...);
```

**Важно**: Добавьте запятую после последней записи предыдущей версии.

#### 3.2. Добавление информации о билде в таблицу `build_info`

Найдите секцию `INSERT INTO \`build_info\`` (примерно строка 1760) и добавьте новую запись:

```sql
(NEW_BUILD,MAJOR,MINOR,BUGFIX,NULL),
```

Например, для версии `11.2.5.64502`:
```sql
(64502,11,2,5,NULL),
```

#### 3.3. Обновление значения по умолчанию для `gamebuild` в таблице `realmlist`

Найдите определение таблицы `realmlist` (примерно строка 3388) и обновите значение по умолчанию:

```sql
`gamebuild` int unsigned NOT NULL DEFAULT 'NEW_BUILD',
```

#### 3.4. Обновление INSERT записи в таблице `realmlist`

Найдите `INSERT INTO \`realmlist\`` (примерно строка 3402) и обновите значение `gamebuild`:

```sql
INSERT INTO `realmlist` VALUES
(1,'Trinity','127.0.0.1','127.0.0.1',NULL,NULL,'255.255.255.0',8085,0,0,1,0,0,NEW_BUILD,1,1);
```

#### 3.5. Добавление записи в таблицу `updates`

Найдите секцию `INSERT INTO \`updates\`` (примерно строка 3929) и добавьте новую запись:

```sql
('YYYY_MM_DD_XX_auth.sql','SHA1_HASH','RELEASED','YYYY-MM-DD HH:MM:SS',0),
```

Где:
- `YYYY_MM_DD_XX_auth.sql` - имя файла обновления (см. шаг 4)
- `SHA1_HASH` - SHA1 хеш файла обновления (вычисляется после создания файла)
- `YYYY-MM-DD HH:MM:SS` - текущая дата и время

### 4. Создание файла обновления

Создайте новый файл в директории `sql/updates/auth/master/` с именем в формате:
```
YYYY_MM_DD_XX_auth.sql
```

Где:
- `YYYY_MM_DD` - текущая дата
- `XX` - порядковый номер обновления за день (обычно `00`)

**Пример**: `2025_11_19_00_auth.sql`

#### Содержимое файла обновления:

```sql
DELETE FROM `build_info` WHERE `build` IN (NEW_BUILD);
INSERT INTO `build_info` (`build`,`majorVersion`,`minorVersion`,`bugfixVersion`,`hotfixVersion`) VALUES
(NEW_BUILD,MAJOR,MINOR,BUGFIX,NULL);

DELETE FROM `build_auth_key` WHERE `build`=NEW_BUILD AND `platform`='Mac' AND `arch`='A64' AND `type`='WoW';
DELETE FROM `build_auth_key` WHERE `build`=NEW_BUILD AND `platform`='Mac' AND `arch`='A64' AND `type`='WoWC';
DELETE FROM `build_auth_key` WHERE `build`=NEW_BUILD AND `platform`='Mac' AND `arch`='x64' AND `type`='WoW';
DELETE FROM `build_auth_key` WHERE `build`=NEW_BUILD AND `platform`='Mac' AND `arch`='x64' AND `type`='WoWC';
DELETE FROM `build_auth_key` WHERE `build`=NEW_BUILD AND `platform`='Win' AND `arch`='A64' AND `type`='WoW';
DELETE FROM `build_auth_key` WHERE `build`=NEW_BUILD AND `platform`='Win' AND `arch`='x64' AND `type`='WoW';
DELETE FROM `build_auth_key` WHERE `build`=NEW_BUILD AND `platform`='Win' AND `arch`='x64' AND `type`='WoWC';
INSERT INTO `build_auth_key` (`build`,`platform`,`arch`,`type`,`key`) VALUES
(NEW_BUILD,'Mac','A64','WoW',0x...),
(NEW_BUILD,'Mac','A64','WoWC',0x...),
(NEW_BUILD,'Mac','x64','WoW',0x...),
(NEW_BUILD,'Mac','x64','WoWC',0x...),
(NEW_BUILD,'Win','A64','WoW',0x...),
(NEW_BUILD,'Win','x64','WoW',0x...),
(NEW_BUILD,'Win','x64','WoWC',0x...);

UPDATE `realmlist` SET `gamebuild`=NEW_BUILD WHERE `gamebuild`=OLD_BUILD;

ALTER TABLE `realmlist` CHANGE `gamebuild` `gamebuild` int unsigned NOT NULL DEFAULT 'NEW_BUILD';
```

**Важно**: Замените `NEW_BUILD` на номер новой версии, `OLD_BUILD` на номер предыдущей версии, и `MAJOR`, `MINOR`, `BUGFIX` на соответствующие значения версии.

### 5. Вычисление SHA1 хеша файла обновления

После создания файла обновления вычислите его SHA1 хеш:

```bash
sha1sum sql/updates/auth/master/YYYY_MM_DD_XX_auth.sql
```

Используйте полученный хеш (в верхнем регистре) в шаге 3.5.

### 6. Проверка изменений

Проверьте, что все изменения корректны:

1. Все ключи аутентификации добавлены для всех платформ
2. Информация о билде добавлена в `build_info`
3. Значение по умолчанию `gamebuild` обновлено
4. INSERT запись в `realmlist` обновлена
5. Запись в таблице `updates` добавлена с правильным SHA1 хешем
6. Файл обновления создан и содержит все необходимые изменения

### 7. Коммит изменений

Создайте коммит с сообщением в формате:

```
Core: Updated allowed build to X.Y.Z.BUILD
```

Например:
```
Core: Updated allowed build to 11.2.5.64502
```

## Пример обновления

Пример обновления с версии `11.2.5.64484` на `11.2.5.64502` можно найти в коммите `daac5296a9`.

## Важные замечания

1. **Порядок операций**: Сначала обновляйте `sql/base/auth_database.sql`, затем создавайте файл обновления
2. **SHA1 хеш**: Всегда вычисляйте SHA1 хеш после создания файла обновления
3. **Формат даты**: Используйте формат `YYYY-MM-DD HH:MM:SS` для времени в таблице `updates`
4. **Статус обновления**: Используйте статус `'RELEASED'` для новых обновлений
5. **Ключи аутентификации**: Убедитесь, что у вас есть все необходимые ключи для всех платформ перед началом обновления

## Дополнительные ресурсы

- История обновлений версий: `git log --grep="allowed build" -i`
- Примеры файлов обновлений: `sql/updates/auth/master/`
- Базовая структура БД: `sql/base/auth_database.sql`

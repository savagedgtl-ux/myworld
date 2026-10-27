// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get accept => 'Принять';

  @override
  String get acceptTerms =>
      'Я принимаю Условия использования и Политику конфиденциальности';

  @override
  String get accessUntil => 'Доступ до';

  @override
  String get adConsent => 'Согласие на рекламу';

  @override
  String get adConsentHelp =>
      'Управляйте настройками персонализированной рекламы. Содержимое ваших документов никогда не используется для рекламы.';

  @override
  String get adLabel => 'Реклама';

  @override
  String get add => 'Добавить';

  @override
  String get addBusinessCard => 'Добавить визитку';

  @override
  String get addBusinessCardHint => 'Сфотографируйте чужую визитку';

  @override
  String get addCategory => 'Новая категория';

  @override
  String get addDocument => 'Добавить документ';

  @override
  String get addFamilyMember => 'Добавить члена семьи';

  @override
  String get addFamilyMemberHint => 'Профиль члена семьи, например ребёнка';

  @override
  String get addFavorite => 'В избранное';

  @override
  String get addImage => 'Загрузить изображение';

  @override
  String get addImageHint => 'Выберите фото из галереи';

  @override
  String get addItem => 'Добавить вещь';

  @override
  String get addItemHint => 'Техника, мебель, снаряжение, коллекция…';

  @override
  String get addMemberHelp =>
      'Для профиля не нужны аккаунт и личные данные. Документы привязываются к профилю; видимость задаётся для каждого документа отдельно.';

  @override
  String get addPage => 'Добавить страницу';

  @override
  String get addPdf => 'Загрузить PDF';

  @override
  String get addPdfHint => 'Готовый PDF с телефона';

  @override
  String get addPhoto => 'Сделать фото';

  @override
  String get addPhotoHint => 'Один снимок с камеры';

  @override
  String get addRecord => 'Добавить запись';

  @override
  String get addReminder => 'Добавить напоминание';

  @override
  String get addReminderHint => 'Срок, продление, годовщина…';

  @override
  String get addRepairReceipt => 'Добавить чек за ремонт';

  @override
  String get addScan => 'Сканировать документ';

  @override
  String get addScanHint => 'Определение краёв, несколько страниц в одном PDF';

  @override
  String get addServiceRecord => 'Чек за обслуживание или расход';

  @override
  String get addServiceRecordHint => 'Для этого автомобиля';

  @override
  String get addTitle => 'Что добавляем?';

  @override
  String get addVehicle => 'Добавить автомобиль';

  @override
  String get addVehicleRecord => 'Запись по автомобилю';

  @override
  String get addVehicleRecordHint => 'ТО, регистрация, топливо, шины…';

  @override
  String get addWalletCard => 'Добавить карту';

  @override
  String get addWalletCardHint => 'Карта лояльности, скидка или купон';

  @override
  String get address => 'Адрес';

  @override
  String get adsOffForPlan => 'В вашем тарифе нет рекламы.';

  @override
  String get aiAnalyze => 'Анализ документа с ИИ';

  @override
  String get aiAnalyzeAgain => 'Проанализировать с ИИ';

  @override
  String get aiAnalyzeHelp =>
      'ИИ предлагает название, дату, сумму и категорию. Вы подтверждаете, прежде чем что-то сохранится.';

  @override
  String get aiAndYourData => 'ИИ и ваши данные';

  @override
  String get aiAnswer => 'Ответ';

  @override
  String get aiDataNote =>
      'При использовании ИИ отправляется только то, что нужно для конкретного запроса: текст или изображение одного документа для анализа либо краткие метаданные доступных записей для вопроса. Документы из сейфа никогда не используются для вопросов. Данные не используются для обучения моделей и не хранятся сервисом ИИ.';

  @override
  String get aiExample1 =>
      'Когда заканчивается гарантия на мою стиральную машину?';

  @override
  String get aiExample2 => 'Сколько я потратил на машину в этом году?';

  @override
  String get aiExample3 =>
      'Найди договоры, которые истекают в ближайшие три месяца.';

  @override
  String get aiExample4 => 'Какие у меня есть чеки за покупки дороже 200 евро?';

  @override
  String get aiFilledCheck => 'Поля заполнены. Проверьте их перед сохранением.';

  @override
  String get aiHint => 'Задайте вопрос о своих данных…';

  @override
  String get aiInsufficientNote =>
      'Я отвечаю только на основе сохранённых данных. Если чего-то не хватает, добавьте документ или заполните данные.';

  @override
  String get aiIntro =>
      'Спрашивайте о своих документах, вещах, автомобилях и сроках. В ответах всегда есть источники.';

  @override
  String aiIndexing(int ready, int total) {
    return 'ИИ читает ваши документы: $ready из $total. Ответы становятся полнее по мере чтения.';
  }

  @override
  String get aiIndexingDeferred =>
      'Месячный лимит чтения документов исчерпан. Остальное ИИ прочитает в начале следующего месяца.';

  @override
  String get aiLimitsNote =>
      'Месячный лимит защищает от неожиданных расходов. Он обнуляется в начале каждого месяца.';

  @override
  String get aiNoData =>
      'У меня недостаточно данных, чтобы ответить на этот вопрос.';

  @override
  String get aiNotInPlanHint =>
      'Анализ с ИИ доступен в тарифах Individual Pro и Family Pro. Документ можно сохранить и отредактировать вручную.';

  @override
  String get aiPrivacyNote =>
      'ИИ видит только записи, к которым у вас есть доступ.';

  @override
  String get aiProcessing => 'ИИ обрабатывает документ…';

  @override
  String get aiRequestsThisMonth => 'Запросы к ИИ в этом месяце';

  @override
  String get aiSearchLocked =>
      'Поиск с ИИ на естественном языке доступен в тарифах Pro';

  @override
  String get aiThinking => 'Ищем в ваших данных…';

  @override
  String get aiUsage => 'Использование ИИ и лимиты';

  @override
  String get aiVerifyNote =>
      'ИИ может ошибаться. Проверяйте важную информацию в источнике.';

  @override
  String get all => 'Все';

  @override
  String get allDocuments => 'Все документы';

  @override
  String get allItems => 'Все вещи';

  @override
  String get allow => 'Разрешить';

  @override
  String get amount => 'Сумма';

  @override
  String get analyticsConsent => 'Анонимная статистика использования';

  @override
  String get analyticsConsentHelp =>
      'Помогает нам улучшать приложение. Никогда не отправляет содержимое, названия или данные документов.';

  @override
  String get anyTime => 'В любое время';

  @override
  String get appTitle => 'MyWorld+';

  @override
  String get appWorksWithoutAi =>
      'Приложение работает и без ИИ: сохранение, просмотр, поиск и напоминания доступны в любом тарифе.';

  @override
  String get apply => 'Применить';

  @override
  String get areaBusinessCards => 'Мои визитки';

  @override
  String get areaBusinessCardsSub => 'Визитки других людей';

  @override
  String get areaCar => 'Мой автомобиль';

  @override
  String get areaCarSub => 'Автомобили и расходы';

  @override
  String get areaCards => 'Мои карты';

  @override
  String get areaCardsSub => 'Скидки и купоны';

  @override
  String get areaDocuments => 'Мои документы';

  @override
  String get areaDocumentsSub => 'Центральный архив';

  @override
  String get areaFamily => 'Моя семья';

  @override
  String get areaFamilySub => 'Семейное пространство';

  @override
  String get areaHobby => 'Моё хобби';

  @override
  String get areaHobbySub => 'Снаряжение и коллекции';

  @override
  String get areaHome => 'Мой дом';

  @override
  String get areaHomeSub => 'Вещи в доме';

  @override
  String get areaLife => 'Моя жизнь';

  @override
  String get areaLifeSub => 'Сроки и обязательства';

  @override
  String get askAi => 'Спросить ИИ';

  @override
  String get askAiInstead => 'Спросить ИИ-ассистента';

  @override
  String get assignedItems => 'Привязанные вещи';

  @override
  String get atTime => 'В момент срока';

  @override
  String get attachReceipt => 'Сканировать чек';

  @override
  String get back => 'Назад';

  @override
  String get backToSignIn => 'Вернуться ко входу';

  @override
  String get balance => 'Баланс';

  @override
  String get barcodeFormat => 'Формат кода';

  @override
  String get barcodeInvalid => 'Код не подходит для выбранного формата';

  @override
  String get barcodeValue => 'Значение кода';

  @override
  String get billingIssueBody =>
      'Платёж не прошёл. Проверьте способ оплаты в магазине приложений, чтобы сохранить функции.';

  @override
  String get billingNotConfigured =>
      'Покупки сейчас недоступны на этом устройстве.';

  @override
  String get brand => 'Бренд';

  @override
  String get brandModel => 'Бренд и модель';

  @override
  String get byCategory => 'По категориям';

  @override
  String get cancel => 'Отмена';

  @override
  String get cardCoupon => 'Купон';

  @override
  String get cardDiscount => 'Скидка';

  @override
  String get cardGift => 'Подарочная карта';

  @override
  String get cardLoyalty => 'Лояльность';

  @override
  String get cardMembership => 'Членство';

  @override
  String get cardName => 'Название';

  @override
  String get cardNameHelp => 'Например, название магазина или аптеки';

  @override
  String get cardNumber => 'Номер карты';

  @override
  String get cardOther => 'Другое';

  @override
  String get categories => 'Категории';

  @override
  String get category => 'Категория';

  @override
  String get changePhoto => 'Сменить фото';

  @override
  String get changePlan => 'Сменить тариф';

  @override
  String get channelLocal => 'Уведомление на устройстве';

  @override
  String get channelLocalHelp => 'Работает без интернета';

  @override
  String get channelPush => 'Push-уведомление';

  @override
  String get channelPushHelp => 'Приходит, даже когда приложение закрыто';

  @override
  String get checkThisField => 'Проверьте это поле';

  @override
  String get chooseCurrency => 'Выберите валюту';

  @override
  String get chooseFromGallery => 'Выбрать из галереи';

  @override
  String get choosePlan => 'Выбрать тариф';

  @override
  String get chooseVehicle => 'Выбрать автомобиль';

  @override
  String get clear => 'Очистить';

  @override
  String get clearFilters => 'Сбросить фильтры';

  @override
  String get close => 'Закрыть';

  @override
  String get code => 'Код';

  @override
  String get color => 'Цвет';

  @override
  String get company => 'Компания';

  @override
  String get confirmAndSave => 'Подтвердить и сохранить';

  @override
  String get confirmDateHint => 'Проверьте дату перед сохранением.';

  @override
  String get contactSupport => 'Написать в поддержку';

  @override
  String get contextSection => 'Контекст';

  @override
  String get continueApple => 'Продолжить с Apple';

  @override
  String get continueGoogle => 'Продолжить с Google';

  @override
  String get continueLabel => 'Продолжить';

  @override
  String get copied => 'Скопировано';

  @override
  String get copy => 'Копировать';

  @override
  String get createAccount => 'Создать аккаунт';

  @override
  String get createFamily => 'Создать семью';

  @override
  String get createInviteLink => 'Создать ссылку-приглашение';

  @override
  String get createReminder => 'Создать напоминание';

  @override
  String get currency => 'Валюта';

  @override
  String get currentMileage => 'Текущий пробег';

  @override
  String get currentMileageKm => 'Текущий пробег (км)';

  @override
  String get currentPlan => 'Текущий';

  @override
  String get date => 'Дата';

  @override
  String get dateOptions => 'В документе несколько дат — выберите нужную:';

  @override
  String get decline => 'Отклонить';

  @override
  String get delete => 'Удалить';

  @override
  String get deleteAccount => 'Удалить аккаунт';

  @override
  String get deleteAccountForever => 'Удалить аккаунт навсегда';

  @override
  String get deleteCancelStoreFirst =>
      'Ваша подписка управляется через App Store / Google Play. Отмените её там, чтобы с вас не списывали деньги после удаления аккаунта.';

  @override
  String get deleteCard => 'Удалить карту';

  @override
  String get deleteCardBody => 'Карта и её фото будут удалены.';

  @override
  String get deleteCategory => 'Удалить категорию';

  @override
  String get deleteCategoryBody =>
      'Документы останутся сохранёнными, у них просто пропадёт эта категория.';

  @override
  String get deleteConsequences =>
      'Будут удалены все ваши документы, файлы, вещи, автомобили, карты, контакты и напоминания. Вы потеряете доступ к семейному пространству. Это действие нельзя отменить.';

  @override
  String get deleteConsequencesTitle => 'Что произойдёт';

  @override
  String get deleteContact => 'Удалить контакт';

  @override
  String get deleteContactBody => 'Визитка и фото будут удалены.';

  @override
  String get deleteForever => 'Удалить навсегда';

  @override
  String get deleteForeverBody =>
      'Файл будет удалён навсегда и не сможет быть восстановлен.';

  @override
  String get deleteItem => 'Удалить вещь';

  @override
  String get deleteItemBody =>
      'Вещь будет удалена. Связанные документы останутся в архиве.';

  @override
  String get deleteProfile => 'Удалить профиль';

  @override
  String get deleteProfileBody =>
      'Профиль будет удалён. Документы останутся, пропадёт только связь.';

  @override
  String get deleteRecord => 'Удалить запись';

  @override
  String get deleteRecordBody =>
      'Запись будет удалена. Прикреплённые чеки останутся в архиве.';

  @override
  String get deleteReminder => 'Удалить напоминание';

  @override
  String get deleteReminderBody =>
      'Напоминание больше не будет присылать уведомления.';

  @override
  String get deleteVehicle => 'Удалить автомобиль';

  @override
  String get deleteVehicleBody =>
      'Автомобиль и его записи будут удалены. Чеки останутся в архиве.';

  @override
  String get deleteWord => 'УДАЛИТЬ';

  @override
  String get description => 'Описание';

  @override
  String get details => 'Подробности';

  @override
  String get disableLock => 'Отключить блокировку';

  @override
  String get discount => 'Скидка';

  @override
  String get discountHelp => 'Например, 10 % на косметику';

  @override
  String get discountText => 'Описание скидки';

  @override
  String get displayName => 'Имя или ник';

  @override
  String get dissolveBody =>
      'Семейное пространство будет закрыто. Ваши документы останутся, но станут личными.';

  @override
  String get dissolveFamily => 'Закрыть семью';

  @override
  String get dissolveHelp =>
      'Как владелец, вы можете закрыть семью, когда в ней не останется других участников.';

  @override
  String get docNotAvailable => 'Документ не существует или у вас нет доступа.';

  @override
  String get documentDate => 'Дата документа';

  @override
  String get documentSaved => 'Документ сохранён';

  @override
  String get documentSavedAi =>
      'ИИ обрабатывает документ. Предложения появятся для проверки.';

  @override
  String get documents => 'Документы';

  @override
  String get done => 'Готово';

  @override
  String get downgradePolicy =>
      'При переходе на меньший тариф ни один файл не удаляется автоматически. Если вы превысили лимит, документы остаются доступными для просмотра и экспорта, но новые нельзя добавить, пока вы не освободите место или не выберете тариф побольше.';

  @override
  String get dueDate => 'Срок';

  @override
  String get duplicateTitle => 'Возможный дубликат';

  @override
  String get edit => 'Изменить';

  @override
  String get editCard => 'Изменить карту';

  @override
  String get editContact => 'Изменить контакт';

  @override
  String get editDetails => 'Изменить данные';

  @override
  String get editDocument => 'Изменить документ';

  @override
  String get editItem => 'Изменить вещь';

  @override
  String get editProfile => 'Изменить профиль';

  @override
  String get editRecord => 'Изменить запись';

  @override
  String get editReminder => 'Изменить напоминание';

  @override
  String get editVehicle => 'Изменить автомобиль';

  @override
  String get email => 'Эл. почта';

  @override
  String get emailChannelNote => 'Уведомления по эл. почте пока не включены.';

  @override
  String get emailOptional => 'Эл. почта (необязательно)';

  @override
  String get emailSent => 'Письмо отправлено';

  @override
  String get emailsOnePerLine => 'Адреса эл. почты (по одному в строке)';

  @override
  String get enableLock => 'Включить блокировку';

  @override
  String get errAiFailed =>
      'ИИ сейчас не может обработать запрос. Ваши данные в безопасности — попробуйте позже.';

  @override
  String get errAiLimit =>
      'Достигнут лимит запросов к ИИ. Попробуйте позже или проверьте использование.';

  @override
  String get errAiNotInPlan =>
      'ИИ доступен в тарифах Individual Pro и Family Pro.';

  @override
  String get errAlreadyInFamily => 'Вы уже состоите в семье.';

  @override
  String get errCancelled => 'Действие отменено.';

  @override
  String get errDocumentLimit =>
      'Вы достигли лимита документов в вашем тарифе.';

  @override
  String get errEmailInUse => 'Аккаунт с этим адресом уже существует.';

  @override
  String get errEmailNotVerified =>
      'Адрес ещё не подтверждён. Проверьте почту.';

  @override
  String get errFamilyFull => 'Для вашего тарифа семья уже заполнена.';

  @override
  String get errFamilyHasMembers => 'Сначала удалите других участников семьи.';

  @override
  String get errFamilyPlan => 'Для этого нужен тариф Family.';

  @override
  String get errFileTooLarge => 'Файл слишком большой (макс. 25 МБ).';

  @override
  String get errGeneric => 'Что-то пошло не так. Попробуйте ещё раз.';

  @override
  String get errInvalidEmail => 'Введите корректный адрес эл. почты.';

  @override
  String get errInvitationEmail =>
      'Это приглашение отправлено на другой адрес.';

  @override
  String get errInvitationExpired => 'Срок приглашения истёк. Попросите новое.';

  @override
  String get errInvitationInvalid =>
      'Приглашение недействительно или уже использовано.';

  @override
  String get errNetwork =>
      'Нет подключения к интернету. Изменения синхронизируются, когда вы снова будете онлайн.';

  @override
  String get errNotFound => 'Запрошенное содержимое не найдено.';

  @override
  String get errPermission => 'У вас нет прав на это действие.';

  @override
  String get errRecentLogin => 'В целях безопасности войдите ещё раз.';

  @override
  String get errSession => 'Сессия истекла. Войдите ещё раз.';

  @override
  String get errStorageLimit => 'Недостаточно места в вашем тарифе.';

  @override
  String get errTitle => 'Упс';

  @override
  String get errTooMany =>
      'Слишком много попыток. Подождите немного и попробуйте снова.';

  @override
  String get errUnavailable =>
      'Сервис временно недоступен. Попробуйте через минуту.';

  @override
  String get errUnsupportedFile =>
      'Этот тип файла не поддерживается. Используйте PDF, JPG, PNG или HEIC.';

  @override
  String get errUserNotFound => 'Аккаунт с этим адресом не найден.';

  @override
  String get errWeakPassword => 'Пароль слишком простой.';

  @override
  String get errWrongPassword => 'Неверный адрес или пароль.';

  @override
  String get expenses => 'Расходы';

  @override
  String get expired => 'Истёк';

  @override
  String get expiryDate => 'Действует до';

  @override
  String get exportAdvancedIncluded =>
      'Ваш тариф также включает таблицы CSV (документы, вещи, расходы на автомобиль).';

  @override
  String get exportBasicOnly =>
      'Экспорт содержит JSON со всеми данными и исходные файлы. Таблицы CSV входят в тарифы Pro.';

  @override
  String get exportBody =>
      'Мы создадим ZIP-архив со всеми вашими документами, фото, метаданными, вещами, автомобилями, напоминаниями и связями между ними.';

  @override
  String get exportData => 'Экспорт данных';

  @override
  String get exportFamilyNote =>
      'Экспорт содержит только записи, владельцем которых вы являетесь. Каждый член семьи экспортирует свои данные сам.';

  @override
  String get exportFirst => 'Сначала экспортировать данные';

  @override
  String get exportWait =>
      'Если файлов много, это может занять несколько минут.';

  @override
  String get familyDeadlines => 'Семейные сроки';

  @override
  String get familyIntro =>
      'Семейное пространство даёт общие документы, профили участников и общие сроки. При этом у каждого документа сохраняются свои настройки приватности.';

  @override
  String get familyInvitation => 'Приглашение в семью';

  @override
  String get familyName => 'Название семьи';

  @override
  String get familyPermissions => 'Роли и права';

  @override
  String get familyPlanLapsed =>
      'Тариф Family не активен. Существующие данные остаются доступными, но новые приглашения невозможны.';

  @override
  String get familyPlanOnly => 'Доступно в тарифах Family';

  @override
  String get familyProfiles => 'Профили членов семьи';

  @override
  String get familyProfilesHelp =>
      'Для участников без своего аккаунта, например детей.';

  @override
  String get familySettings => 'Настройки семьи';

  @override
  String get faq1a =>
      'По умолчанию только вы. Документ становится виден членам семьи, только если вы измените его приватность на «Выбранные» или «Семья».';

  @override
  String get faq1q => 'Кто может видеть мои документы?';

  @override
  String get faq2a =>
      'Ничего не удаляется. Всё остаётся доступным для просмотра и экспорта; добавить новые файлы можно после того, как освободите место или смените тариф.';

  @override
  String get faq2q => 'Что будет, если я превышу объём хранилища?';

  @override
  String get faq3a =>
      'Да. Поэтому данные от ИИ — это предложения, которые вы подтверждаете, а в ответах всегда указаны источники.';

  @override
  String get faq3q => 'Может ли ИИ ошибаться?';

  @override
  String get faq4a =>
      'Подпиской управляют в настройках App Store или Google Play. Доступ сохраняется до конца оплаченного периода.';

  @override
  String get faq4q => 'Как отменить подписку?';

  @override
  String get faq5a =>
      'Нет. PIN-код и биометрия добавляют защиту экрана. Файлы защищены правилами доступа на сервере и шифруются Google Cloud при передаче и хранении.';

  @override
  String get faq5q => 'PIN-код сейфа — это шифрование?';

  @override
  String get favorites => 'Избранное';

  @override
  String get favoritesOnly => 'Только избранное';

  @override
  String get featureAds => 'С рекламой';

  @override
  String get featureAi => 'Распознавание, категоризация и вопросы с ИИ';

  @override
  String get featureNoAds => 'Без рекламы';

  @override
  String get featureNoAi => 'Без функций ИИ';

  @override
  String get featureReminders => 'Напоминания и уведомления';

  @override
  String get featureScan => 'Сканирование и загрузка';

  @override
  String get fileInfo => 'Файл';

  @override
  String get fileType => 'Тип файла';

  @override
  String get filters => 'Фильтры';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get free => 'Бесплатно';

  @override
  String get front => 'Лицевая сторона';

  @override
  String get fuelType => 'Топливо / привод';

  @override
  String get fullName => 'Полное имя';

  @override
  String get getStarted => 'Начать';

  @override
  String get goHome => 'На главную';

  @override
  String get gridView => 'Плиткой';

  @override
  String get haveAccount => 'У меня уже есть аккаунт';

  @override
  String get haveInvitationHint =>
      'Есть приглашение? Откройте ссылку из сообщения и примите его.';

  @override
  String get help => 'Помощь и поддержка';

  @override
  String get hidePassword => 'Скрыть пароль';

  @override
  String get howWeProtect => 'Как мы защищаем ваши данные';

  @override
  String get iVerified => 'Я подтвердил адрес';

  @override
  String get ignoreSuggestions => 'Игнорировать предложения';

  @override
  String get image => 'Изображение';

  @override
  String get importantReminders => 'Важные напоминания';

  @override
  String get injectionWarning =>
      'В документе есть текст, похожий на инструкции для ИИ. Он был проигнорирован, но внимательно проверьте предложения.';

  @override
  String get invalidAmount => 'Некорректная сумма';

  @override
  String get invalidValue => 'Некорректное значение';

  @override
  String get invalidVin => 'VIN состоит из 17 символов (без I, O, Q)';

  @override
  String get invitationDeclined => 'Приглашение отклонено';

  @override
  String get invite => 'Пригласить';

  @override
  String get inviteEmailHelp =>
      'Если указать адрес, принять приглашение сможет только человек с этим подтверждённым адресом.';

  @override
  String get inviteExpiresNote =>
      'Ссылка действует 7 дней и может быть использована только один раз.';

  @override
  String get inviteHelp =>
      'Создайте защищённую ссылку-приглашение и отправьте её члену семьи. Участники не получают доступ к вашим документам автоматически.';

  @override
  String get inviteLink => 'Ссылка-приглашение';

  @override
  String get inviteMember => 'Пригласить участника';

  @override
  String get inviteReady => 'Приглашение готово';

  @override
  String get issuer => 'Выдавший / магазин';

  @override
  String get items => 'Вещи';

  @override
  String get jobTitle => 'Должность';

  @override
  String get joinedFamily => 'Вы присоединились к семье';

  @override
  String get kindAnniversary => 'Годовщина';

  @override
  String get kindContract => 'Договор';

  @override
  String get kindCustom => 'Другое';

  @override
  String get kindDocument => 'Документ';

  @override
  String get kindInsurance => 'Страховка';

  @override
  String get kindRegistration => 'Регистрация';

  @override
  String get kindService => 'Обслуживание';

  @override
  String get kindSubscription => 'Подписка / членство';

  @override
  String get kindWarranty => 'Гарантия';

  @override
  String get langEnglish => 'Английский';

  @override
  String get langFrench => 'Французский';

  @override
  String get langGerman => 'Немецкий';

  @override
  String get langSpanish => 'Испанский';

  @override
  String get langRussian => 'Русский';

  @override
  String get langSerbian => 'Сербский';

  @override
  String get language => 'Язык';

  @override
  String get largestFiles => 'Самые большие файлы';

  @override
  String get last30Days => 'Последние 30 дней';

  @override
  String get lastMileage => 'Последний пробег';

  @override
  String get lastYear => 'Прошлый год';

  @override
  String get later => 'Позже';

  @override
  String get leaveFamily => 'Выйти из семьи';

  @override
  String get leaveFamilyBody =>
      'Вы потеряете доступ к семейным документам. Ваши документы останутся вашими и станут личными.';

  @override
  String get leaveFamilyTitle => 'Выйти из семьи?';

  @override
  String get legal => 'Правовая информация';

  @override
  String get legalSummary =>
      'MyWorld+ хранит ваши данные только для работы сервиса. Мы не продаём данные, не используем содержимое документов для рекламы и не обучаем модели на ваших документах. Вы можете экспортировать или удалить свои данные в любой момент.';

  @override
  String get lifeIntro =>
      'Подписки, полисы, сроки договоров, членства, годовщины и другие важные даты.';

  @override
  String get limitReachedBody =>
      'Ничего не удалено. Все ваши записи остаются доступными для просмотра и экспорта. Чтобы добавить новые, освободите место (очистите корзину, удалите ненужное) или выберите тариф побольше.';

  @override
  String get limitReachedTitle => 'Достигнут лимит тарифа';

  @override
  String get linkedDocument => 'Связанный документ';

  @override
  String get linkedDocumentOptional => 'Связанный документ (необязательно)';

  @override
  String get linkedItem => 'Связанная вещь';

  @override
  String get links => 'Связи';

  @override
  String get linksHelp =>
      'Свяжите документ с вещами, автомобилями или участниками. Файл не копируется.';

  @override
  String get listView => 'Списком';

  @override
  String get loading => 'Загрузка…';

  @override
  String get location => 'Место в доме';

  @override
  String get locationHelp => 'Например, кухня, подвал';

  @override
  String get lockEnabled => 'Блокировка включена';

  @override
  String get lockNow => 'Заблокировать сейчас';

  @override
  String get lockedFeature => 'Недоступно';

  @override
  String get maintenanceHistory => 'Ремонт и обслуживание';

  @override
  String get make => 'Марка';

  @override
  String get manage => 'Управлять';

  @override
  String get manageInStore => 'Управлять в магазине';

  @override
  String get manageSubscription => 'Подписка';

  @override
  String get markDone => 'Отметить выполненным';

  @override
  String get markDoneNext => 'Готово — перейти к следующей дате';

  @override
  String get markUsed => 'Отметить использованным';

  @override
  String get member => 'Участник';

  @override
  String get memberVisibleNote =>
      'Вы видите только то, чем этот участник поделился с вами или с семьёй.';

  @override
  String get members => 'Участники';

  @override
  String get metAt => 'Дата знакомства';

  @override
  String get metWhere => 'Где познакомились';

  @override
  String get mileage => 'Пробег';

  @override
  String get mileageHistory => 'История пробега';

  @override
  String get mileageKm => 'Пробег (км)';

  @override
  String get minor => 'Несовершеннолетний';

  @override
  String get minorHelp => 'Профиль ребёнка — не аккаунт, с ним нельзя войти.';

  @override
  String get model => 'Модель';

  @override
  String get more => 'Ещё';

  @override
  String get moveToTrash => 'В корзину';

  @override
  String get moveToTrashBody =>
      'Документ можно восстановить из корзины в течение 30 дней.';

  @override
  String get movedToTrash => 'Перемещено в корзину';

  @override
  String get multiCurrencyNote => 'Суммы в разных валютах не складываются.';

  @override
  String get myAreas => 'Мои разделы';

  @override
  String get name => 'Имя';

  @override
  String get nameOrCompanyRequired => 'Введите имя или компанию';

  @override
  String get navAdd => 'Добавить';

  @override
  String get navHome => 'Главная';

  @override
  String get navVault => 'Сейф';

  @override
  String get navWorld => 'Мой мир';

  @override
  String get next => 'Далее';

  @override
  String get next6Months => 'Следующие 6 месяцев';

  @override
  String get nextDueDate => 'Следующий срок';

  @override
  String get nextDueHelp =>
      'Заполняйте, только если знаете (например, из чека или по рекомендации сервиса).';

  @override
  String get nextDueMileage => 'Следующее ТО на пробеге, км';

  @override
  String get nextDueSection => 'Следующий срок';

  @override
  String get noAccount => 'Нет аккаунта? Зарегистрируйтесь';

  @override
  String get noAssignedItems => 'Нет привязанных вещей.';

  @override
  String get noCards => 'Карт пока нет';

  @override
  String get noCardsHint =>
      'Сохраняйте карты лояльности, скидки и купоны, чтобы они всегда были под рукой.';

  @override
  String get noContacts => 'Визиток пока нет';

  @override
  String get noContactsHint =>
      'Сфотографируйте визитку и сохраните контакт за секунды.';

  @override
  String get noDeadlines => 'Нет сроков в ближайшие 6 месяцев';

  @override
  String get noDocuments => 'Документов пока нет';

  @override
  String get noDocumentsCta =>
      'Добавьте первый документ — отсканируйте чек или гарантию.';

  @override
  String get noDocumentsHint =>
      'Отсканируйте или загрузите документ, чтобы хранить его здесь.';

  @override
  String get noExpenses => 'Расходов пока нет';

  @override
  String get noFamilyDeadlines => 'Нет общих сроков.';

  @override
  String get noInventedIntervals =>
      'MyWorld+ не придумывает интервалы обслуживания — показываются только даты, которые вы ввели.';

  @override
  String get noItems => 'Вещей пока нет';

  @override
  String get noItemsHint =>
      'Добавьте технику или вещь и привяжите к ней чек и гарантию.';

  @override
  String get noLinkTargets => 'Нет вещей, автомобилей или профилей для связи.';

  @override
  String get noLinkedDocs => 'Нет связанных документов.';

  @override
  String get noLinks => 'Этот документ ни с чем не связан.';

  @override
  String get noMaintenance => 'Нет записей об обслуживании';

  @override
  String get noMaintenanceHint =>
      'Добавьте чек за ремонт или обслуживание, связанный с вещью.';

  @override
  String get noMileage => 'Пробег не записан';

  @override
  String get noNotifications => 'Новых уведомлений нет';

  @override
  String get noRecordYet => 'Записей пока нет.';

  @override
  String get noRecords => 'Записей пока нет';

  @override
  String get noReminders => 'Нет напоминаний';

  @override
  String get noRemindersCta =>
      'Добавьте первое напоминание — регистрация, гарантия, договор…';

  @override
  String get noRemindersHint => 'Напоминания вовремя сообщат о важных сроках.';

  @override
  String get noResults => 'Ничего не найдено';

  @override
  String get noResultsFiltered => 'Нет документов, подходящих под фильтры.';

  @override
  String get noResultsHint =>
      'Попробуйте другой запрос, сбросьте фильтры или добавьте документ.';

  @override
  String get noSharedDocs => 'Нет общих документов.';

  @override
  String get noSharedDocsHint =>
      'Измените приватность документа на «Семья» или «Выбранные», чтобы его видели другие.';

  @override
  String get noSuggestions => 'Нет предложений от ИИ';

  @override
  String get noSuggestionsBody => 'Для этого документа пока нет предложений.';

  @override
  String get noVehicles => 'Автомобилей пока нет';

  @override
  String get noVehiclesHint =>
      'Добавьте автомобиль, чтобы следить за историей обслуживания, расходами и сроками.';

  @override
  String get noWarrantyDate => 'Дата окончания гарантии не указана';

  @override
  String get noWarrantyFound =>
      'В документе не найдено данных о гарантии. Мы не придумываем срок гарантии.';

  @override
  String get none => 'Нет';

  @override
  String get notAvailable => 'Недоступно или нет доступа.';

  @override
  String get notSet => 'не задано';

  @override
  String get notes => 'Заметки';

  @override
  String get notificationChannels => 'Каналы уведомлений';

  @override
  String get notificationGenericBody =>
      'У вас есть напоминание, требующее внимания.';

  @override
  String get notificationTitle => 'Напоминание MyWorld+';

  @override
  String get notifications => 'Уведомления';

  @override
  String get notificationsAllowed => 'Уведомления разрешены';

  @override
  String get notificationsBlocked => 'Уведомления запрещены';

  @override
  String get notifyBefore => 'Напомнить';

  @override
  String get offlineBanner => 'Нет сети — изменения синхронизируются позже';

  @override
  String get onboarding1Body =>
      'Документы, чеки, гарантии, вещи, автомобили и семья — всё по порядку.';

  @override
  String get onboarding1Title => 'Всё важное — в одном месте.';

  @override
  String get onboarding2Body =>
      'Сфотографируйте — и мы создадим аккуратный PDF.';

  @override
  String get onboarding2Title =>
      'Сохраняйте документы, чеки и гарантии за секунды.';

  @override
  String get onboarding3Body => 'Быстрый поиск и напоминания о важных сроках.';

  @override
  String get onboarding3Title => 'Находите нужное именно тогда, когда нужно.';

  @override
  String get open => 'Открыть';

  @override
  String get openDocument => 'Открыть документ';

  @override
  String get openPreview => 'Открыть просмотр';

  @override
  String get openSourceLicenses => 'Лицензии открытого ПО';

  @override
  String get openingCamera => 'Открываем камеру…';

  @override
  String get optionalDetails => 'Дополнительные данные (необязательно)';

  @override
  String get orContinueWith => 'или';

  @override
  String get overdue => 'Просрочено';

  @override
  String get ownerCannotLeave =>
      'Владелец не может выйти, пока в семье есть другие участники. Сначала удалите их.';

  @override
  String get pageNotFound => 'Такой страницы не существует.';

  @override
  String get password => 'Пароль';

  @override
  String get passwordHelp => 'Минимум 8 символов, буквы и цифры';

  @override
  String get passwordTooShort => 'Пароль должен содержать минимум 8 символов';

  @override
  String get passwordWeak => 'Пароль должен содержать буквы и цифры';

  @override
  String get pendingInvites => 'Ожидающие приглашения';

  @override
  String get period => 'Период';

  @override
  String get permissionDeniedTitle => 'Нет доступа';

  @override
  String get permissionsExplainer =>
      'Роли определяют, кто управляет семьёй (приглашения, профили). Роль никогда не даёт доступ к чужим документам — это решают настройки приватности каждого документа.';

  @override
  String get phonesOnePerLine => 'Телефоны (по одному в строке)';

  @override
  String get photos => 'Фото';

  @override
  String get pin => 'PIN-код';

  @override
  String get pinHelp => 'От 4 до 8 цифр';

  @override
  String get pinMismatch => 'PIN-коды не совпадают';

  @override
  String get pinNew => 'Новый PIN-код';

  @override
  String get pinRepeat => 'Повторите PIN-код';

  @override
  String get planFamilyBase => 'Family Base';

  @override
  String get planFamilyPro => 'Family Pro';

  @override
  String get planFromFamily => 'Тариф предоставлен вашей семьёй';

  @override
  String get planIndividualBase => 'Individual Base';

  @override
  String get planIndividualPro => 'Individual Pro';

  @override
  String get plansSubtitle =>
      'Выберите подходящий тариф. Его можно изменить или отменить в любой момент.';

  @override
  String get plansTitle => 'Тарифы';

  @override
  String get price => 'Цена';

  @override
  String get privacy => 'Кто видит';

  @override
  String get privacyBullets =>
      '• Все файлы приватны и доступны только после проверки доступа на сервере.\n• Члены семьи видят только то, чем вы явно поделились.\n• Содержимое документов никогда не отправляется в аналитику, журналы или рекламные сети.\n• Удаление аккаунта действительно удаляет данные с сервера.';

  @override
  String get privacyFamily => 'Семья';

  @override
  String get privacyFamilyHelp => 'Видят все активные участники вашей семьи.';

  @override
  String get privacyNoFamilyHelp =>
      'Делиться можно, когда вы состоите в семье.';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get privacyPrivate => 'Только я';

  @override
  String get privacyPrivateHelp => 'Видите только вы.';

  @override
  String get privacySettings => 'Конфиденциальность';

  @override
  String get privacyShared => 'Выбранные';

  @override
  String get privacySharedHelp => 'Видят только выбранные вами участники.';

  @override
  String get processingStatus => 'Статус обработки';

  @override
  String get profile => 'Профиль';

  @override
  String get profileSetupBody =>
      'Всего пара данных. Ничего личного мы не спрашиваем.';

  @override
  String get profileSetupTitle => 'Ваш профиль';

  @override
  String get purchaseDate => 'Дата покупки';

  @override
  String get purchaseDetails => 'Покупка';

  @override
  String get purchaseProcessed => 'Покупка обработана. Обновляем ваш тариф…';

  @override
  String get reactivate => 'Возобновить';

  @override
  String get readCardWithAi => 'Распознать карту с ИИ';

  @override
  String get recFuel => 'Топливо';

  @override
  String get recInspection => 'Техосмотр';

  @override
  String get recInsurance => 'Страховка';

  @override
  String get recOil => 'Замена масла';

  @override
  String get recOther => 'Другое';

  @override
  String get recParking => 'Парковка';

  @override
  String get recParts => 'Запчасти';

  @override
  String get recRegistration => 'Регистрация';

  @override
  String get recRepair => 'Ремонт';

  @override
  String get recService => 'Плановое ТО';

  @override
  String get recTires => 'Шины';

  @override
  String get recTolls => 'Платные дороги';

  @override
  String get receipts => 'Чеки';

  @override
  String get receiptsAndWarranties => 'Чеки и гарантии';

  @override
  String get recentRecords => 'Последние записи';

  @override
  String get recentlyAdded => 'Недавно добавленные';

  @override
  String get recordType => 'Тип записи';

  @override
  String get refreshStatus => 'Обновить статус подписки';

  @override
  String get registrationInsurance => 'Регистрация и страховка';

  @override
  String get registrationNumber => 'Госномер';

  @override
  String get relationshipOptional => 'Кем приходится (необязательно)';

  @override
  String get remindBeforeExpiry => 'Напомнить до истечения срока';

  @override
  String get reminder => 'Напоминание';

  @override
  String get reminderSaved => 'Напоминание сохранено';

  @override
  String get reminderSettings => 'Настройки напоминаний';

  @override
  String get reminderType => 'Тип';

  @override
  String get reminders => 'Напоминания';

  @override
  String get removeAds => 'Убрать рекламу';

  @override
  String get removeFavorite => 'Убрать из избранного';

  @override
  String get removeMember => 'Удалить участника';

  @override
  String get removeMemberBody =>
      'Участник сразу теряет доступ к семейным и общим документам. Его собственные документы остаются за ним.';

  @override
  String get renewsOn => 'Продлится';

  @override
  String get repeat => 'Повтор';

  @override
  String get repeatDaily => 'Каждый день';

  @override
  String get repeatMonthly => 'Каждый месяц';

  @override
  String get repeatNone => 'Не повторять';

  @override
  String get repeatWeekly => 'Каждую неделю';

  @override
  String get repeatYearly => 'Каждый год';

  @override
  String get required => 'Обязательное поле';

  @override
  String get resendEmail => 'Отправить письмо ещё раз';

  @override
  String get resetPassword => 'Сбросить пароль';

  @override
  String get resetPasswordBody =>
      'Введите адрес эл. почты, и мы пришлём ссылку для установки нового пароля.';

  @override
  String get resetSentBody =>
      'Если аккаунт существует, ссылка отправлена. Проверьте также папку «Спам».';

  @override
  String get resetSentTitle => 'Проверьте почту';

  @override
  String get restore => 'Восстановить';

  @override
  String get restoreDone => 'Покупки проверены';

  @override
  String get restorePurchases => 'Восстановить покупки';

  @override
  String get restored => 'Восстановлено';

  @override
  String get retake => 'Переснять';

  @override
  String get retry => 'Повторить';

  @override
  String get reviewSuggestions => 'Проверить предложения ИИ';

  @override
  String get revoke => 'Отозвать';

  @override
  String get roleAdmin => 'Администратор';

  @override
  String get roleMember => 'Участник';

  @override
  String get roleOwner => 'Владелец';

  @override
  String get rotate => 'Повернуть';

  @override
  String get save => 'Сохранить';

  @override
  String get saveAnyway => 'Всё равно сохранить';

  @override
  String get saveDocumentTitle => 'Сохранить документ';

  @override
  String get saveToVault => 'Сохранить в сейф';

  @override
  String get saveToVaultHelp =>
      'Для особенно важных личных документов. Никогда не используются в вопросах к ИИ.';

  @override
  String get saved => 'Сохранено';

  @override
  String get scanBarcode => 'Сканировать штрихкод / QR';

  @override
  String get scanBarcodeHelp => 'Наведите камеру на штрихкод или QR-код';

  @override
  String get scanReviewHelp =>
      'Проверьте страницы. Их можно повернуть, переснять, удалить или перетащить, чтобы изменить порядок.';

  @override
  String get search => 'Поиск';

  @override
  String get searchCards => 'Поиск карт';

  @override
  String get searchContacts => 'Поиск контактов';

  @override
  String get searchHint => 'Что ищем сегодня?';

  @override
  String get searchItems => 'Поиск вещей';

  @override
  String get searchStartBody =>
      'Ищите по названию, категории, продавцу, человеку, устройству, сумме или тегу.';

  @override
  String get searchStartTitle => 'Начните вводить';

  @override
  String get searchVault => 'Поиск в сейфе';

  @override
  String get seeAll => 'Все';

  @override
  String get seePlans => 'Смотреть тарифы';

  @override
  String get send => 'Отправить';

  @override
  String get sendLink => 'Отправить ссылку';

  @override
  String get serialNumber => 'Серийный номер';

  @override
  String get serviceHistory => 'История обслуживания';

  @override
  String get serviceOrVendor => 'Сервис или продавец';

  @override
  String get sessionExpiredBody => 'В целях безопасности войдите ещё раз.';

  @override
  String get sessionExpiredTitle => 'Сессия истекла';

  @override
  String get setPin => 'Установить PIN-код сейфа';

  @override
  String get settings => 'Настройки';

  @override
  String get share => 'Поделиться';

  @override
  String get shareFile => 'Экспортировать файл';

  @override
  String get sharedByMe => 'Я поделился';

  @override
  String get sharedDocuments => 'Общие документы';

  @override
  String get sharedWithMe => 'Поделились со мной';

  @override
  String get sharing => 'Доступ и приватность';

  @override
  String get sharingNeedsFamily =>
      'В тарифах Family можно делиться документами с членами семьи.';

  @override
  String get sharingServerNote =>
      'Доступ проверяется на сервере для каждого документа и файла. Когда вы закрываете кому-то доступ, он теряет его сразу.';

  @override
  String get sharingUpdated => 'Доступ обновлён';

  @override
  String get showCompleted => 'Показать выполненные';

  @override
  String get showDetailsHelp =>
      'Выкл.: на экране блокировки видно только, что есть напоминание. Вкл.: показывается название напоминания.';

  @override
  String get showDetailsInNotifications => 'Показывать название в уведомлении';

  @override
  String get showPassword => 'Показать пароль';

  @override
  String get showUsedExpired => 'Показать использованные и истёкшие';

  @override
  String get signIn => 'Войти';

  @override
  String get signInTitle => 'С возвращением';

  @override
  String get signInAsTester => 'Войти как тестировщик';

  @override
  String get signOut => 'Выйти';

  @override
  String get signUpTitle => 'Создайте свой MyWorld+';

  @override
  String get skip => 'Пропустить';

  @override
  String get snoozeWeek => 'Отложить на неделю';

  @override
  String get soon => 'Скоро';

  @override
  String get sortAmountAsc => 'Сначала дешевле';

  @override
  String get sortAmountDesc => 'Сначала дороже';

  @override
  String get sortBy => 'Сортировка';

  @override
  String get sortExpiry => 'Срок действия';

  @override
  String get sortNameAsc => 'Название А–Я';

  @override
  String get sortNameDesc => 'Название Я–А';

  @override
  String get sortNewest => 'Сначала новые';

  @override
  String get sortOldest => 'Сначала старые';

  @override
  String get source => 'Источник';

  @override
  String get sources => 'Источники';

  @override
  String get startExport => 'Создать экспорт';

  @override
  String get status => 'Статус';

  @override
  String get statusActive => 'Активно';

  @override
  String get statusCancelled => 'Отменено';

  @override
  String get statusDiscarded => 'Отклонено';

  @override
  String get statusDone => 'Выполнено';

  @override
  String get statusDraft => 'Черновик';

  @override
  String get statusFailed => 'Ошибка';

  @override
  String get statusInRepair => 'В ремонте';

  @override
  String get statusNeedsReview => 'Нужна проверка';

  @override
  String get statusProcessing => 'Обрабатывается';

  @override
  String get statusReady => 'Готово';

  @override
  String get statusRefreshed => 'Статус обновлён';

  @override
  String get statusSnoozed => 'Отложено';

  @override
  String get statusSold => 'Продано';

  @override
  String get statusUploaded => 'Загружено';

  @override
  String get statusUploading => 'Загружается';

  @override
  String get storage => 'Хранилище';

  @override
  String get storageAlmostFull => 'Хранилище почти заполнено';

  @override
  String get subActive => 'Активна';

  @override
  String get subBillingIssue => 'Проблема с оплатой';

  @override
  String get subCancelled => 'Отменена — действует до конца периода';

  @override
  String get subExpired => 'Истекла';

  @override
  String get subNone => 'Бесплатный тариф';

  @override
  String get subRefunded => 'Возвращена';

  @override
  String get subscriptionTerms =>
      'Подписка продлевается каждый месяц, пока вы не отмените её в настройках App Store или Google Play. Оплата списывается с вашего аккаунта в магазине.';

  @override
  String get summary => 'Сводка';

  @override
  String get supportPrivacyNote =>
      'Никогда не отправляйте в поддержку пароли или содержимое документов.';

  @override
  String get tagline => 'Ваша жизнь. В одном месте.';

  @override
  String get tags => 'Теги';

  @override
  String get takePhoto => 'Сделать фото';

  @override
  String get termsOfUse => 'Условия использования';

  @override
  String get thisYear => 'Этот год';

  @override
  String get timezone => 'Часовой пояс';

  @override
  String get title => 'Название';

  @override
  String get today => 'Сегодня';

  @override
  String get tomorrow => 'Завтра';

  @override
  String get totalInvested => 'Всего вложено';

  @override
  String get totalValue => 'Общая стоимость';

  @override
  String get trash => 'Корзина';

  @override
  String get trashEmpty => 'Корзина пуста';

  @override
  String get trashRetention =>
      'Документы в корзине удаляются навсегда через 30 дней.';

  @override
  String get tryAi => 'Спросить ИИ';

  @override
  String get typeDeleteToConfirm => 'Введите УДАЛИТЬ для подтверждения';

  @override
  String get unlock => 'Разблокировать';

  @override
  String get unlockVaultReason => 'Разблокировать сейф';

  @override
  String get upcomingDeadlines => 'Ближайшие сроки';

  @override
  String get upgradeAiBody =>
      'ИИ читает чеки, предлагает категории и напоминания и отвечает на вопросы о ваших данных — со ссылками на источники.';

  @override
  String get upgradeAiTitle => 'Помощь ИИ — в тарифах Pro';

  @override
  String get upgradeDocumentsBody =>
      'Вы достигли лимита документов бесплатного тарифа. Ничего не удаляется — выберите тариф побольше, чтобы было больше места.';

  @override
  String get upgradeDocumentsTitle => 'Лимит документов';

  @override
  String get upgradeExportBody => 'Экспорт в CSV входит в тарифы Pro.';

  @override
  String get upgradeExportTitle => 'Расширенный экспорт';

  @override
  String get upgradeFamilyBody =>
      'Семейное пространство, приглашения и общий доступ к документам доступны в Family Base и Family Pro.';

  @override
  String get upgradeFamilyTitle => 'Тариф Family';

  @override
  String get upgradeFiltersBody =>
      'Фильтры по статусу обработки и расширенный поиск — в платных тарифах.';

  @override
  String get upgradeFiltersTitle => 'Расширенные фильтры';

  @override
  String get upgradeStorageBody =>
      'Ничего не удалено. Выберите тариф побольше или освободите место.';

  @override
  String get upgradeStorageTitle => 'Хранилище заполнено';

  @override
  String get upgradeVehiclesBody =>
      'Ваш тариф допускает ограниченное число автомобилей. Тариф побольше позволяет больше.';

  @override
  String get upgradeVehiclesTitle => 'Лимит автомобилей';

  @override
  String get uploadErrorTitle => 'Не удалось загрузить';

  @override
  String get uploadFailedHint =>
      'Файл не загрузился или не прошёл проверку. Загрузите его снова.';

  @override
  String get uploadKeepOpen =>
      'Не закрывайте приложение, пока загрузка не завершится.';

  @override
  String get useBiometrics => 'Использовать биометрию';

  @override
  String get useRegularSearch => 'Обычный поиск';

  @override
  String get validFrom => 'Действует с';

  @override
  String get vaultEmpty => 'Сейф пуст';

  @override
  String get vaultEmptyBody =>
      'Храните здесь личные документы, договоры, полисы и свидетельства.';

  @override
  String get vaultLockDisclaimer =>
      'PIN-код и биометрия добавляют защиту при открытии сейфа на этом устройстве. Это не шифрование: ваши файлы защищены проверками доступа на сервере независимо от PIN-кода.';

  @override
  String get vaultLocked => 'Сейф заблокирован';

  @override
  String get vaultLockedBody => 'Введите PIN-код или используйте биометрию.';

  @override
  String get vaultSettings => 'Настройки сейфа';

  @override
  String get vaultSubtitle =>
      'Личные и особенно важные документы. Здесь нет рекламы.';

  @override
  String get vendor => 'Продавец';

  @override
  String get verifyEmailTitle => 'Подтвердите адрес эл. почты';

  @override
  String get warrantiesExpiring => 'Истекающие гарантии';

  @override
  String get warranty => 'Гарантия';

  @override
  String get warrantyConfirm => 'Я подтверждаю дату гарантии';

  @override
  String get warrantyConfirmHelp =>
      'Проверьте гарантийный талон. Гарантия никогда не устанавливается без вашего подтверждения.';

  @override
  String get warrantyFieldHelp =>
      'Заполняйте, только если это указано в гарантийном талоне';

  @override
  String get warrantySuggestion => 'Предложение из документа';

  @override
  String get warrantyUntil => 'Гарантия до';

  @override
  String get warrantyUserEnteredNote =>
      'Дата гарантии — та, которую вы ввели или подтвердили.';

  @override
  String get website => 'Сайт';

  @override
  String get welcome => 'Добро пожаловать';

  @override
  String get withReminder => 'С напоминанием';

  @override
  String get withWarranty => 'С гарантией';

  @override
  String get worldSubtitle => 'Все сферы вашей жизни';

  @override
  String get year => 'Год';

  @override
  String get you => 'вы';

  @override
  String addDocumentFor(String name) {
    return 'Документ для: $name';
  }

  @override
  String cardExpiresTitle(String name) {
    return 'Истекает карта: $name';
  }

  @override
  String cardsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count карты',
      many: '$count карт',
      few: '$count карты',
      one: '$count карта',
      zero: 'Нет карт',
    );
    return '$_temp0';
  }

  @override
  String cardsExpiringSoon(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count карты истекают в течение 2 недель',
      many: '$count карт истекают в течение 2 недель',
      few: '$count карты истекают в течение 2 недель',
      one: '$count карта истекает в течение 2 недель',
    );
    return '$_temp0';
  }

  @override
  String contactsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count контакта',
      many: '$count контактов',
      few: '$count контакта',
      one: '$count контакт',
      zero: 'Нет контактов',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дня назад',
      many: '$count дней назад',
      few: '$count дня назад',
      one: '$count день назад',
    );
    return '$_temp0';
  }

  @override
  String daysBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'за $count дня',
      many: 'за $count дней',
      few: 'за $count дня',
      one: 'за $count день',
    );
    return '$_temp0';
  }

  @override
  String documentExpiresTitle(String title) {
    return 'Истекает: $title';
  }

  @override
  String documentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count документа',
      many: '$count документов',
      few: '$count документа',
      one: '$count документ',
      zero: 'Нет документов',
    );
    return '$_temp0';
  }

  @override
  String documentsUsed(int used, int limit) {
    return 'Документы: $used из $limit';
  }

  @override
  String duplicateBody(String title) {
    return 'Такой же файл уже сохранён как «$title». Сохранить ещё раз?';
  }

  @override
  String expiresOn(String date) {
    return 'Истекает $date';
  }

  @override
  String featureDocuments(String count) {
    return 'До $count документов';
  }

  @override
  String featureMembers(int count) {
    return 'До $count членов семьи';
  }

  @override
  String featureStorage(String size) {
    return '$size хранилища';
  }

  @override
  String helloName(String name) {
    return 'Привет, $name';
  }

  @override
  String hoursBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'за $count часа',
      many: 'за $count часов',
      few: 'за $count часа',
      one: 'за $count час',
    );
    return '$_temp0';
  }

  @override
  String inDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'через $count дня',
      many: 'через $count дней',
      few: 'через $count дня',
      one: 'через $count день',
    );
    return '$_temp0';
  }

  @override
  String invitationBody(String name) {
    return '$name приглашает вас в своё семейное пространство. Приняв приглашение, вы не получаете доступ ко всем документам — вы видите только то, чем с вами делятся.';
  }

  @override
  String inviteShareText(String link) {
    return 'Присоединяйся к нашей семье в MyWorld+: $link';
  }

  @override
  String invitedTo(String name) {
    return 'Приглашение в «$name»';
  }

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count вещи',
      many: '$count вещей',
      few: '$count вещи',
      one: '$count вещь',
      zero: 'Нет вещей',
    );
    return '$_temp0';
  }

  @override
  String joinedOn(String date) {
    return 'Участник с $date';
  }

  @override
  String last12Months(String currency) {
    return 'Последние 12 месяцев $currency';
  }

  @override
  String lastOn(String date) {
    return 'Последний раз: $date';
  }

  @override
  String membersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count участника',
      many: '$count участников',
      few: '$count участника',
      one: '$count участник',
    );
    return '$_temp0';
  }

  @override
  String minutesBefore(int count) {
    return 'за $count мин';
  }

  @override
  String nextDue(String date) {
    return 'Следующий: $date';
  }

  @override
  String offerReminderBody(String date) {
    return 'Создать напоминание на $date?';
  }

  @override
  String pageN(int n) {
    return 'Страница $n';
  }

  @override
  String pagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count страницы',
      many: '$count страниц',
      few: '$count страницы',
      one: '$count страница',
    );
    return '$_temp0';
  }

  @override
  String pricePerMonth(String price) {
    return '$price € / мес.';
  }

  @override
  String purchasedOn(String date) {
    return 'Куплено $date';
  }

  @override
  String remindersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count напоминания',
      many: '$count напоминаний',
      few: '$count напоминания',
      one: '$count напоминание',
      zero: 'Нет напоминаний',
    );
    return '$_temp0';
  }

  @override
  String removeMemberTitle(String name) {
    return 'Удалить участника $name?';
  }

  @override
  String reviewIntro(int percent) {
    return 'ИИ прочитал документ (уверенность $percent %). Проверьте и исправьте данные перед сохранением.';
  }

  @override
  String reviewNeededFor(String title) {
    return 'Проверьте предложения: $title';
  }

  @override
  String scanReviewTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count страницы',
      many: '$count страниц',
      few: '$count страницы',
      one: '$count страница',
    );
    return '$_temp0';
  }

  @override
  String sharedBy(String name) {
    return 'Поделился: $name';
  }

  @override
  String storageUsed(String used, String total) {
    return 'Занято $used из $total';
  }

  @override
  String uploadProgress(int percent) {
    return 'Загрузка… $percent %';
  }

  @override
  String validUntil(String date) {
    return 'Действует до $date';
  }

  @override
  String vehiclesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count автомобиля',
      many: '$count автомобилей',
      few: '$count автомобиля',
      one: '$count автомобиль',
      zero: 'Нет автомобилей',
    );
    return '$_temp0';
  }

  @override
  String verifyEmailBody(String email) {
    return 'Мы отправили ссылку на $email. Откройте её, чтобы подтвердить аккаунт.';
  }

  @override
  String warrantyActiveUntil(String date) {
    return 'Гарантия действует до $date';
  }

  @override
  String warrantyDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'До конца гарантии $count дня',
      many: 'До конца гарантии $count дней',
      few: 'До конца гарантии $count дня',
      one: 'До конца гарантии $count день',
    );
    return '$_temp0';
  }

  @override
  String warrantyExpiredOn(String date) {
    return 'Гарантия закончилась $date';
  }

  @override
  String warrantyExpiresTitle(String name) {
    return 'Заканчивается гарантия: $name';
  }

  @override
  String warrantyPrintedMonths(int months) {
    return 'В документе: гарантия $months мес.';
  }

  @override
  String warrantyPrintedUntil(String date) {
    return 'В документе: до $date';
  }

  @override
  String warrantyUntilShort(String date) {
    return 'Гарантия до $date';
  }

  @override
  String willBeSavedIn(String destination) {
    return 'Будет сохранено в: $destination';
  }

  @override
  String wrongPin(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Неверный PIN-код. Осталось $count попытки.',
      many: 'Неверный PIN-код. Осталось $count попыток.',
      few: 'Неверный PIN-код. Осталось $count попытки.',
      one: 'Неверный PIN-код. Осталась $count попытка.',
    );
    return '$_temp0';
  }

  @override
  String get suggestedLinks => 'Предлагаемые связи';

  @override
  String get suggestedLinksHelp =>
      'Мы нашли записи, подходящие к этому документу. Отметьте те, которые хотите связать.';
}

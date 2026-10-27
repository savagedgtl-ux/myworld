// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get accept => 'Aceptar';

  @override
  String get acceptTerms =>
      'Acepto los Términos de uso y la Política de privacidad';

  @override
  String get accessUntil => 'Acceso hasta';

  @override
  String get adConsent => 'Consentimiento de anuncios';

  @override
  String get adConsentHelp =>
      'Gestiona tus preferencias de anuncios personalizados. El contenido de tus documentos nunca se usa para anuncios.';

  @override
  String get adLabel => 'Anuncio';

  @override
  String get add => 'Añadir';

  @override
  String get addBusinessCard => 'Añadir tarjeta de visita';

  @override
  String get addBusinessCardHint =>
      'Fotografía la tarjeta de visita de alguien';

  @override
  String get addCategory => 'Nueva categoría';

  @override
  String get addDocument => 'Añadir documento';

  @override
  String get addFamilyMember => 'Añadir miembro de la familia';

  @override
  String get addFamilyMemberHint =>
      'Perfil de un miembro del hogar, p. ej. un hijo';

  @override
  String get addFavorite => 'Añadir a favoritos';

  @override
  String get addImage => 'Subir imagen';

  @override
  String get addImageHint => 'Elige fotos de tu galería';

  @override
  String get addItem => 'Añadir objeto';

  @override
  String get addItemHint => 'Electrodoméstico, mueble, equipo, colección…';

  @override
  String get addMemberHelp =>
      'Un perfil no necesita cuenta ni datos sensibles. Los documentos se vinculan al perfil; cada documento controla su propia visibilidad.';

  @override
  String get addPage => 'Añadir página';

  @override
  String get addPdf => 'Subir PDF';

  @override
  String get addPdfHint => 'Un PDF que ya tienes en el móvil';

  @override
  String get addPhoto => 'Hacer foto';

  @override
  String get addPhotoHint => 'Una sola foto con la cámara';

  @override
  String get addRecord => 'Añadir registro';

  @override
  String get addReminder => 'Añadir recordatorio';

  @override
  String get addReminderHint => 'Plazo, renovación, aniversario…';

  @override
  String get addRepairReceipt => 'Añadir recibo de reparación';

  @override
  String get addScan => 'Escanear documento';

  @override
  String get addScanHint => 'Detección de bordes, varias páginas en un PDF';

  @override
  String get addServiceRecord => 'Recibo de mantenimiento o gasto';

  @override
  String get addServiceRecordHint => 'Para este vehículo';

  @override
  String get addTitle => '¿Qué vas a añadir?';

  @override
  String get addVehicle => 'Añadir vehículo';

  @override
  String get addVehicleRecord => 'Registro del vehículo';

  @override
  String get addVehicleRecordHint =>
      'Mantenimiento, matriculación, combustible, neumáticos…';

  @override
  String get addWalletCard => 'Añadir tarjeta';

  @override
  String get addWalletCardHint => 'Tarjeta de fidelidad, descuento o cupón';

  @override
  String get address => 'Dirección';

  @override
  String get adsOffForPlan => 'Tu plan no tiene anuncios.';

  @override
  String get aiAnalyze => 'Análisis del documento con IA';

  @override
  String get aiAnalyzeAgain => 'Analizar con IA';

  @override
  String get aiAnalyzeHelp =>
      'La IA sugiere título, fecha, importe y categoría. Tú confirmas antes de guardar nada.';

  @override
  String get aiAndYourData => 'La IA y tus datos';

  @override
  String get aiAnswer => 'Respuesta';

  @override
  String get aiDataNote =>
      'Cuando usas la IA, solo se envía lo necesario para esa solicitud: el texto o la imagen de un documento para el análisis, o metadatos breves de registros permitidos para una pregunta. Los documentos de la caja fuerte nunca se usan para preguntas. Los datos no se usan para entrenar modelos y el servicio de IA no los guarda.';

  @override
  String get aiExample1 => '¿Cuándo vence la garantía de mi lavadora?';

  @override
  String get aiExample2 => '¿Cuánto he gastado en el coche este año?';

  @override
  String get aiExample3 =>
      'Busca contratos que venzan en los próximos tres meses.';

  @override
  String get aiExample4 => '¿Qué recibos tengo de compras de más de 200 euros?';

  @override
  String get aiFilledCheck => 'Campos rellenados. Revísalos antes de guardar.';

  @override
  String get aiHint => 'Haz una pregunta sobre tus datos…';

  @override
  String get aiInsufficientNote =>
      'Solo respondo a partir de tus datos guardados. Si falta algo, añade un documento o completa los datos.';

  @override
  String get aiIntro =>
      'Pregunta sobre tus documentos, objetos, vehículos y plazos. Las respuestas siempre incluyen fuentes.';

  @override
  String aiIndexing(int ready, int total) {
    return 'La IA está leyendo tus documentos: $ready de $total. Las respuestas serán más completas a medida que avance.';
  }

  @override
  String get aiIndexingDeferred =>
      'Se alcanzó el límite mensual de lectura de documentos. La IA leerá el resto a principios del próximo mes.';

  @override
  String get aiLimitsNote =>
      'El límite mensual evita costes inesperados. Se reinicia al principio de cada mes.';

  @override
  String get aiNoData =>
      'No tengo suficientes datos para responder a esta pregunta.';

  @override
  String get aiNotInPlanHint =>
      'El análisis con IA está disponible en Individual Pro y Family Pro. Puedes guardar y editar el documento manualmente.';

  @override
  String get aiPrivacyNote =>
      'La IA solo ve los registros a los que tienes acceso.';

  @override
  String get aiProcessing => 'La IA está procesando el documento…';

  @override
  String get aiRequestsThisMonth => 'Solicitudes de IA este mes';

  @override
  String get aiSearchLocked =>
      'La búsqueda con IA en lenguaje natural está disponible en los planes Pro';

  @override
  String get aiThinking => 'Buscando en tus datos…';

  @override
  String get aiUsage => 'Uso de la IA y límites';

  @override
  String get aiVerifyNote =>
      'La IA puede equivocarse. Comprueba la información importante en la fuente.';

  @override
  String get all => 'Todos';

  @override
  String get allDocuments => 'Todos los documentos';

  @override
  String get allItems => 'Todos los objetos';

  @override
  String get allow => 'Permitir';

  @override
  String get amount => 'Importe';

  @override
  String get analyticsConsent => 'Estadísticas de uso anónimas';

  @override
  String get analyticsConsentHelp =>
      'Nos ayuda a mejorar la app. Nunca envía contenido, títulos ni datos de documentos.';

  @override
  String get anyTime => 'En cualquier momento';

  @override
  String get appTitle => 'MyWorld+';

  @override
  String get appWorksWithoutAi =>
      'La app funciona sin IA: guardar, ver, buscar y los recordatorios están disponibles en todos los planes.';

  @override
  String get apply => 'Aplicar';

  @override
  String get areaBusinessCards => 'Mis tarjetas de visita';

  @override
  String get areaBusinessCardsSub => 'Tarjetas de otras personas';

  @override
  String get areaCar => 'Mi coche';

  @override
  String get areaCarSub => 'Vehículos y gastos';

  @override
  String get areaCards => 'Mis tarjetas';

  @override
  String get areaCardsSub => 'Descuentos y cupones';

  @override
  String get areaDocuments => 'Mis documentos';

  @override
  String get areaDocumentsSub => 'Archivo central';

  @override
  String get areaFamily => 'Mi familia';

  @override
  String get areaFamilySub => 'Espacio familiar';

  @override
  String get areaHobby => 'Mi afición';

  @override
  String get areaHobbySub => 'Equipo y colecciones';

  @override
  String get areaHome => 'Mi hogar';

  @override
  String get areaHomeSub => 'Cosas de casa';

  @override
  String get areaLife => 'Mi vida';

  @override
  String get areaLifeSub => 'Plazos y obligaciones';

  @override
  String get askAi => 'Preguntar a la IA';

  @override
  String get askAiInstead => 'Preguntar al asistente de IA';

  @override
  String get assignedItems => 'Objetos asignados';

  @override
  String get atTime => 'En el momento del vencimiento';

  @override
  String get attachReceipt => 'Escanear recibo';

  @override
  String get back => 'Atrás';

  @override
  String get backToSignIn => 'Volver a iniciar sesión';

  @override
  String get balance => 'Saldo';

  @override
  String get barcodeFormat => 'Formato del código';

  @override
  String get barcodeInvalid =>
      'El código no es válido para el formato seleccionado';

  @override
  String get barcodeValue => 'Valor del código';

  @override
  String get billingIssueBody =>
      'El pago ha fallado. Revisa tu método de pago en la tienda para conservar tus funciones.';

  @override
  String get billingNotConfigured =>
      'Las compras no están disponibles en este dispositivo por ahora.';

  @override
  String get brand => 'Marca';

  @override
  String get brandModel => 'Marca y modelo';

  @override
  String get byCategory => 'Por categoría';

  @override
  String get cancel => 'Cancelar';

  @override
  String get cardCoupon => 'Cupón';

  @override
  String get cardDiscount => 'Descuento';

  @override
  String get cardGift => 'Tarjeta regalo';

  @override
  String get cardLoyalty => 'Fidelidad';

  @override
  String get cardMembership => 'Membresía';

  @override
  String get cardName => 'Nombre';

  @override
  String get cardNameHelp => 'P. ej. el nombre de una tienda o farmacia';

  @override
  String get cardNumber => 'Número de tarjeta';

  @override
  String get cardOther => 'Otra';

  @override
  String get categories => 'Categorías';

  @override
  String get category => 'Categoría';

  @override
  String get changePhoto => 'Cambiar foto';

  @override
  String get changePlan => 'Cambiar plan';

  @override
  String get channelLocal => 'Notificación en el dispositivo';

  @override
  String get channelLocalHelp => 'Funciona sin conexión';

  @override
  String get channelPush => 'Notificación push';

  @override
  String get channelPushHelp => 'Llega aunque la app esté cerrada';

  @override
  String get checkThisField => 'Revisa este campo';

  @override
  String get chooseCurrency => 'Elige una moneda';

  @override
  String get chooseFromGallery => 'Elegir de la galería';

  @override
  String get choosePlan => 'Elegir plan';

  @override
  String get chooseVehicle => 'Elegir vehículo';

  @override
  String get clear => 'Borrar';

  @override
  String get clearFilters => 'Borrar filtros';

  @override
  String get close => 'Cerrar';

  @override
  String get code => 'Código';

  @override
  String get color => 'Color';

  @override
  String get company => 'Empresa';

  @override
  String get confirmAndSave => 'Confirmar y guardar';

  @override
  String get confirmDateHint => 'Comprueba la fecha antes de guardar.';

  @override
  String get contactSupport => 'Contactar con soporte';

  @override
  String get contextSection => 'Contexto';

  @override
  String get continueApple => 'Continuar con Apple';

  @override
  String get continueGoogle => 'Continuar con Google';

  @override
  String get continueLabel => 'Continuar';

  @override
  String get copied => 'Copiado';

  @override
  String get copy => 'Copiar';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get createFamily => 'Crear familia';

  @override
  String get createInviteLink => 'Crear enlace de invitación';

  @override
  String get createReminder => 'Crear recordatorio';

  @override
  String get currency => 'Moneda';

  @override
  String get currentMileage => 'Kilometraje actual';

  @override
  String get currentMileageKm => 'Kilometraje actual (km)';

  @override
  String get currentPlan => 'Actual';

  @override
  String get date => 'Fecha';

  @override
  String get dateOptions =>
      'El documento muestra varias fechas: elige la correcta:';

  @override
  String get decline => 'Rechazar';

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteAccount => 'Eliminar cuenta';

  @override
  String get deleteAccountForever => 'Eliminar la cuenta definitivamente';

  @override
  String get deleteCancelStoreFirst =>
      'Tu suscripción la gestiona App Store / Google Play. Cancélala allí para que no se te cobre después de eliminar la cuenta.';

  @override
  String get deleteCard => 'Eliminar tarjeta';

  @override
  String get deleteCardBody => 'Se eliminarán la tarjeta y sus fotos.';

  @override
  String get deleteCategory => 'Eliminar categoría';

  @override
  String get deleteCategoryBody =>
      'Los documentos siguen guardados; solo pierden esta categoría.';

  @override
  String get deleteConsequences =>
      'Se eliminan todos tus documentos, archivos, objetos, vehículos, tarjetas, contactos y recordatorios. Pierdes el acceso al espacio familiar. No se puede deshacer.';

  @override
  String get deleteConsequencesTitle => 'Qué ocurre';

  @override
  String get deleteContact => 'Eliminar contacto';

  @override
  String get deleteContactBody =>
      'Se eliminarán la tarjeta de visita y las fotos.';

  @override
  String get deleteForever => 'Eliminar definitivamente';

  @override
  String get deleteForeverBody =>
      'El archivo se eliminará definitivamente y no se podrá recuperar.';

  @override
  String get deleteItem => 'Eliminar objeto';

  @override
  String get deleteItemBody =>
      'El objeto se elimina. Los documentos vinculados siguen en tu archivo.';

  @override
  String get deleteProfile => 'Eliminar perfil';

  @override
  String get deleteProfileBody =>
      'El perfil se elimina. Los documentos se quedan, solo pierden el vínculo.';

  @override
  String get deleteRecord => 'Eliminar registro';

  @override
  String get deleteRecordBody =>
      'El registro se eliminará. Los recibos adjuntos siguen en tu archivo.';

  @override
  String get deleteReminder => 'Eliminar recordatorio';

  @override
  String get deleteReminderBody =>
      'El recordatorio dejará de enviar notificaciones.';

  @override
  String get deleteVehicle => 'Eliminar vehículo';

  @override
  String get deleteVehicleBody =>
      'Se eliminan el vehículo y sus registros. Los recibos siguen en tu archivo.';

  @override
  String get deleteWord => 'ELIMINAR';

  @override
  String get description => 'Descripción';

  @override
  String get details => 'Detalles';

  @override
  String get disableLock => 'Desactivar bloqueo';

  @override
  String get discount => 'Descuento';

  @override
  String get discountHelp => 'P. ej. 10 % en cosmética';

  @override
  String get discountText => 'Descripción del descuento';

  @override
  String get displayName => 'Nombre o apodo';

  @override
  String get dissolveBody =>
      'Se cierra el espacio familiar. Tus documentos se quedan, pero pasan a ser privados.';

  @override
  String get dissolveFamily => 'Cerrar familia';

  @override
  String get dissolveHelp =>
      'Como propietario, puedes cerrar la familia cuando no quede ningún otro miembro.';

  @override
  String get docNotAvailable => 'El documento no existe o no tienes acceso.';

  @override
  String get documentDate => 'Fecha del documento';

  @override
  String get documentSaved => 'Documento guardado';

  @override
  String get documentSavedAi =>
      'La IA está procesando el documento. Las sugerencias aparecerán para revisarlas.';

  @override
  String get documents => 'Documentos';

  @override
  String get done => 'Hecho';

  @override
  String get downgradePolicy =>
      'Si pasas a un plan menor, no se elimina ningún archivo automáticamente. Si superas el límite, los documentos siguen disponibles para ver y exportar, pero no puedes añadir nuevos hasta liberar espacio o elegir un plan mayor.';

  @override
  String get dueDate => 'Fecha de vencimiento';

  @override
  String get duplicateTitle => 'Posible duplicado';

  @override
  String get edit => 'Editar';

  @override
  String get editCard => 'Editar tarjeta';

  @override
  String get editContact => 'Editar contacto';

  @override
  String get editDetails => 'Editar detalles';

  @override
  String get editDocument => 'Editar documento';

  @override
  String get editItem => 'Editar objeto';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get editRecord => 'Editar registro';

  @override
  String get editReminder => 'Editar recordatorio';

  @override
  String get editVehicle => 'Editar vehículo';

  @override
  String get email => 'Correo electrónico';

  @override
  String get emailChannelNote =>
      'Las notificaciones por correo aún no están activadas.';

  @override
  String get emailOptional => 'Correo electrónico (opcional)';

  @override
  String get emailSent => 'Correo enviado';

  @override
  String get emailsOnePerLine => 'Correos (uno por línea)';

  @override
  String get enableLock => 'Activar bloqueo';

  @override
  String get errAiFailed =>
      'La IA no puede procesar la solicitud ahora. Tus datos están a salvo: inténtalo más tarde.';

  @override
  String get errAiLimit =>
      'Has alcanzado el límite de solicitudes de IA. Inténtalo más tarde o revisa tu uso.';

  @override
  String get errAiNotInPlan =>
      'La IA está disponible en Individual Pro y Family Pro.';

  @override
  String get errAlreadyInFamily => 'Ya estás en una familia.';

  @override
  String get errCancelled => 'Acción cancelada.';

  @override
  String get errDocumentLimit =>
      'Has alcanzado el límite de documentos de tu plan.';

  @override
  String get errEmailInUse => 'Ya existe una cuenta con este correo.';

  @override
  String get errEmailNotVerified =>
      'El correo aún no está verificado. Revisa tu bandeja de entrada.';

  @override
  String get errFamilyFull => 'La familia está completa para tu plan.';

  @override
  String get errFamilyHasMembers =>
      'Primero elimina a los demás miembros de la familia.';

  @override
  String get errFamilyPlan => 'Esto requiere un plan Family.';

  @override
  String get errFileTooLarge => 'El archivo es demasiado grande (máx. 25 MB).';

  @override
  String get errGeneric => 'Algo ha salido mal. Inténtalo de nuevo.';

  @override
  String get errInvalidEmail => 'Introduce un correo electrónico válido.';

  @override
  String get errInvitationEmail =>
      'Esta invitación se envió a otro correo electrónico.';

  @override
  String get errInvitationExpired =>
      'La invitación ha caducado. Pide una nueva.';

  @override
  String get errInvitationInvalid =>
      'La invitación no es válida o ya se ha usado.';

  @override
  String get errNetwork =>
      'Sin conexión a Internet. Los cambios se sincronizarán cuando vuelvas a estar en línea.';

  @override
  String get errNotFound => 'No se ha encontrado el contenido solicitado.';

  @override
  String get errPermission => 'No tienes permiso para esto.';

  @override
  String get errRecentLogin => 'Por seguridad, vuelve a iniciar sesión.';

  @override
  String get errSession => 'Tu sesión ha caducado. Vuelve a iniciar sesión.';

  @override
  String get errStorageLimit => 'No hay suficiente almacenamiento en tu plan.';

  @override
  String get errTitle => 'Vaya';

  @override
  String get errTooMany =>
      'Demasiados intentos. Espera un momento e inténtalo de nuevo.';

  @override
  String get errUnavailable =>
      'El servicio no está disponible temporalmente. Inténtalo dentro de un minuto.';

  @override
  String get errUnsupportedFile =>
      'Este tipo de archivo no es compatible. Usa PDF, JPG, PNG o HEIC.';

  @override
  String get errUserNotFound => 'No hay ninguna cuenta con este correo.';

  @override
  String get errWeakPassword => 'La contraseña es demasiado débil.';

  @override
  String get errWrongPassword => 'Correo o contraseña incorrectos.';

  @override
  String get expenses => 'Gastos';

  @override
  String get expired => 'Caducado';

  @override
  String get expiryDate => 'Válido hasta';

  @override
  String get exportAdvancedIncluded =>
      'Tu plan también incluye tablas CSV (documentos, objetos, gastos del vehículo).';

  @override
  String get exportBasicOnly =>
      'La exportación contiene un JSON con todos los datos y los archivos originales. Las tablas CSV forman parte de los planes Pro.';

  @override
  String get exportBody =>
      'Crearemos un archivo ZIP con todos tus documentos, fotos, metadatos, objetos, vehículos, recordatorios y los vínculos entre ellos.';

  @override
  String get exportData => 'Exportar datos';

  @override
  String get exportFamilyNote =>
      'La exportación solo contiene los registros de los que eres propietario. Cada miembro de la familia exporta sus propios datos.';

  @override
  String get exportFirst => 'Exportar datos primero';

  @override
  String get exportWait =>
      'Puede tardar unos minutos si tienes muchos archivos.';

  @override
  String get familyDeadlines => 'Plazos familiares';

  @override
  String get familyIntro =>
      'Un espacio familiar ofrece documentos compartidos, perfiles de miembros y plazos comunes. Cada documento mantiene su propia privacidad.';

  @override
  String get familyInvitation => 'Invitación familiar';

  @override
  String get familyName => 'Nombre de la familia';

  @override
  String get familyPermissions => 'Roles y permisos';

  @override
  String get familyPlanLapsed =>
      'El plan Family no está activo. Los datos existentes siguen disponibles, pero no se pueden enviar nuevas invitaciones.';

  @override
  String get familyPlanOnly => 'Disponible en los planes Family';

  @override
  String get familyProfiles => 'Perfiles del hogar';

  @override
  String get familyProfilesHelp =>
      'Para miembros sin cuenta propia, p. ej. niños.';

  @override
  String get familySettings => 'Ajustes de la familia';

  @override
  String get faq1a =>
      'Por defecto, solo tú. Un documento solo es visible para los miembros de la familia si cambias su privacidad a «Seleccionados» o «Familia».';

  @override
  String get faq1q => '¿Quién puede ver mis documentos?';

  @override
  String get faq2a =>
      'No se elimina nada. Todo sigue disponible para ver y exportar; podrás añadir archivos nuevos cuando liberes espacio o mejores tu plan.';

  @override
  String get faq2q => '¿Qué pasa si supero mi almacenamiento?';

  @override
  String get faq3a =>
      'Sí. Por eso los datos de la IA son sugerencias que tú confirmas y las respuestas siempre citan fuentes.';

  @override
  String get faq3q => '¿Puede equivocarse la IA?';

  @override
  String get faq4a =>
      'Gestionas tu suscripción en los ajustes de App Store o Google Play. El acceso se mantiene hasta el final del periodo pagado.';

  @override
  String get faq4q => '¿Cómo cancelo mi suscripción?';

  @override
  String get faq5a =>
      'No. El PIN y la biometría añaden protección a la pantalla. Los archivos están protegidos por reglas de acceso en el servidor y Google Cloud los cifra en tránsito y en reposo.';

  @override
  String get faq5q => '¿El PIN de la caja fuerte es cifrado?';

  @override
  String get favorites => 'Favoritos';

  @override
  String get favoritesOnly => 'Solo favoritos';

  @override
  String get featureAds => 'Con anuncios';

  @override
  String get featureAi => 'Extracción, categorización y preguntas con IA';

  @override
  String get featureNoAds => 'Sin anuncios';

  @override
  String get featureNoAi => 'Sin funciones de IA';

  @override
  String get featureReminders => 'Recordatorios y notificaciones';

  @override
  String get featureScan => 'Escaneo y subida de archivos';

  @override
  String get fileInfo => 'Archivo';

  @override
  String get fileType => 'Tipo de archivo';

  @override
  String get filters => 'Filtros';

  @override
  String get forgotPassword => '¿Has olvidado la contraseña?';

  @override
  String get free => 'Gratis';

  @override
  String get front => 'Anverso';

  @override
  String get fuelType => 'Combustible / propulsión';

  @override
  String get fullName => 'Nombre completo';

  @override
  String get getStarted => 'Empezar';

  @override
  String get goHome => 'Ir al inicio';

  @override
  String get gridView => 'Vista de cuadrícula';

  @override
  String get haveAccount => 'Ya tengo una cuenta';

  @override
  String get haveInvitationHint =>
      '¿Tienes una invitación? Abre el enlace del mensaje y acéptala.';

  @override
  String get help => 'Ayuda y soporte';

  @override
  String get hidePassword => 'Ocultar contraseña';

  @override
  String get howWeProtect => 'Cómo protegemos tus datos';

  @override
  String get iVerified => 'He verificado mi correo';

  @override
  String get ignoreSuggestions => 'Ignorar sugerencias';

  @override
  String get image => 'Imagen';

  @override
  String get importantReminders => 'Recordatorios importantes';

  @override
  String get injectionWarning =>
      'El documento contiene texto que parece instrucciones para la IA. Se ha ignorado, pero revisa las sugerencias con atención.';

  @override
  String get invalidAmount => 'Importe no válido';

  @override
  String get invalidValue => 'Valor no válido';

  @override
  String get invalidVin => 'Un VIN tiene 17 caracteres (sin I, O, Q)';

  @override
  String get invitationDeclined => 'Invitación rechazada';

  @override
  String get invite => 'Invitar';

  @override
  String get inviteEmailHelp =>
      'Si introduces un correo, solo podrá aceptar una persona con esa dirección verificada.';

  @override
  String get inviteExpiresNote =>
      'El enlace es válido 7 días y solo se puede usar una vez.';

  @override
  String get inviteHelp =>
      'Crea un enlace de invitación seguro y envíalo a un miembro de la familia. Los miembros no obtienen acceso automático a tus documentos.';

  @override
  String get inviteLink => 'Enlace de invitación';

  @override
  String get inviteMember => 'Invitar a un miembro';

  @override
  String get inviteReady => 'Invitación lista';

  @override
  String get issuer => 'Emisor / tienda';

  @override
  String get items => 'Objetos';

  @override
  String get jobTitle => 'Cargo';

  @override
  String get joinedFamily => 'Te has unido a la familia';

  @override
  String get kindAnniversary => 'Aniversario';

  @override
  String get kindContract => 'Contrato';

  @override
  String get kindCustom => 'Otro';

  @override
  String get kindDocument => 'Documento';

  @override
  String get kindInsurance => 'Seguro';

  @override
  String get kindRegistration => 'Matriculación';

  @override
  String get kindService => 'Mantenimiento';

  @override
  String get kindSubscription => 'Suscripción / membresía';

  @override
  String get kindWarranty => 'Garantía';

  @override
  String get langEnglish => 'Inglés';

  @override
  String get langFrench => 'Francés';

  @override
  String get langGerman => 'Alemán';

  @override
  String get langSpanish => 'Español';

  @override
  String get langRussian => 'Ruso';

  @override
  String get langSerbian => 'Serbio';

  @override
  String get language => 'Idioma';

  @override
  String get largestFiles => 'Archivos más grandes';

  @override
  String get last30Days => 'Últimos 30 días';

  @override
  String get lastMileage => 'Último kilometraje';

  @override
  String get lastYear => 'El año pasado';

  @override
  String get later => 'Más tarde';

  @override
  String get leaveFamily => 'Salir de la familia';

  @override
  String get leaveFamilyBody =>
      'Pierdes el acceso a los documentos de la familia. Tus documentos siguen siendo tuyos y pasan a ser privados.';

  @override
  String get leaveFamilyTitle => '¿Salir de la familia?';

  @override
  String get legal => 'Información legal';

  @override
  String get legalSummary =>
      'MyWorld+ guarda tus datos solo para prestar el servicio. No vendemos datos, no usamos el contenido de los documentos para anuncios y no entrenamos modelos con tus documentos. Puedes exportar o eliminar tus datos en cualquier momento.';

  @override
  String get lifeIntro =>
      'Suscripciones, pólizas, plazos de contratos, membresías, aniversarios y otras fechas importantes.';

  @override
  String get limitReachedBody =>
      'No se ha eliminado nada. Todos tus elementos siguen disponibles para ver y exportar. Para añadir nuevos, libera espacio (vacía la papelera, elimina lo que no necesites) o elige un plan mayor.';

  @override
  String get limitReachedTitle => 'Límite del plan alcanzado';

  @override
  String get linkedDocument => 'Documento vinculado';

  @override
  String get linkedDocumentOptional => 'Documento vinculado (opcional)';

  @override
  String get linkedItem => 'Objeto vinculado';

  @override
  String get links => 'Vínculos';

  @override
  String get linksHelp =>
      'Vincula el documento a objetos, vehículos o miembros. El archivo no se copia.';

  @override
  String get listView => 'Vista de lista';

  @override
  String get loading => 'Cargando…';

  @override
  String get location => 'Ubicación en casa';

  @override
  String get locationHelp => 'P. ej. cocina, sótano';

  @override
  String get lockEnabled => 'El bloqueo está activado';

  @override
  String get lockNow => 'Bloquear ahora';

  @override
  String get lockedFeature => 'Bloqueado';

  @override
  String get maintenanceHistory => 'Reparaciones y mantenimiento';

  @override
  String get make => 'Fabricante';

  @override
  String get manage => 'Gestionar';

  @override
  String get manageInStore => 'Gestionar en la tienda';

  @override
  String get manageSubscription => 'Suscripción';

  @override
  String get markDone => 'Marcar como hecho';

  @override
  String get markDoneNext => 'Hecho: pasar a la próxima fecha';

  @override
  String get markUsed => 'Marcar como usado';

  @override
  String get member => 'Miembro';

  @override
  String get memberVisibleNote =>
      'Solo ves lo que este miembro ha compartido contigo o con la familia.';

  @override
  String get members => 'Miembros';

  @override
  String get metAt => 'Fecha en que os conocisteis';

  @override
  String get metWhere => 'Dónde os conocisteis';

  @override
  String get mileage => 'Kilometraje';

  @override
  String get mileageHistory => 'Historial de kilometraje';

  @override
  String get mileageKm => 'Kilometraje (km)';

  @override
  String get minor => 'Menor';

  @override
  String get minorHelp =>
      'El perfil de un niño no es una cuenta y no puede iniciar sesión.';

  @override
  String get model => 'Modelo';

  @override
  String get more => 'Más';

  @override
  String get moveToTrash => 'Mover a la papelera';

  @override
  String get moveToTrashBody =>
      'Puedes recuperar el documento de la papelera durante 30 días.';

  @override
  String get movedToTrash => 'Movido a la papelera';

  @override
  String get multiCurrencyNote =>
      'Los importes en monedas distintas no se suman.';

  @override
  String get myAreas => 'Mis áreas';

  @override
  String get name => 'Nombre';

  @override
  String get nameOrCompanyRequired => 'Introduce un nombre o una empresa';

  @override
  String get navAdd => 'Añadir';

  @override
  String get navHome => 'Inicio';

  @override
  String get navVault => 'Caja fuerte';

  @override
  String get navWorld => 'Mi mundo';

  @override
  String get next => 'Siguiente';

  @override
  String get next6Months => 'Próximos 6 meses';

  @override
  String get nextDueDate => 'Próximo vencimiento';

  @override
  String get nextDueHelp =>
      'Rellénalo solo si lo sabes (p. ej. por el recibo o la recomendación del taller).';

  @override
  String get nextDueMileage => 'Próximo mantenimiento a los km';

  @override
  String get nextDueSection => 'Próximo vencimiento';

  @override
  String get noAccount => '¿No tienes cuenta? Regístrate';

  @override
  String get noAssignedItems => 'No hay objetos asignados.';

  @override
  String get noCards => 'Aún no hay tarjetas';

  @override
  String get noCardsHint =>
      'Guarda tarjetas de fidelidad, descuentos y cupones para tenerlos siempre a mano.';

  @override
  String get noContacts => 'Aún no hay tarjetas de visita';

  @override
  String get noContactsHint =>
      'Fotografía una tarjeta de visita y guarda el contacto en segundos.';

  @override
  String get noDeadlines => 'No hay plazos en los próximos 6 meses';

  @override
  String get noDocuments => 'Aún no hay documentos';

  @override
  String get noDocumentsCta =>
      'Añade tu primer documento: escanea un recibo o una garantía.';

  @override
  String get noDocumentsHint =>
      'Escanea o sube un documento para guardarlo aquí.';

  @override
  String get noExpenses => 'Aún no hay gastos';

  @override
  String get noFamilyDeadlines => 'No hay plazos compartidos.';

  @override
  String get noInventedIntervals =>
      'MyWorld+ no supone intervalos de mantenimiento: solo muestra las fechas que has introducido.';

  @override
  String get noItems => 'Aún no hay objetos';

  @override
  String get noItemsHint =>
      'Añade un electrodoméstico u objeto y vincula su recibo y su garantía.';

  @override
  String get noLinkTargets =>
      'No hay objetos, vehículos ni perfiles para vincular.';

  @override
  String get noLinkedDocs => 'No hay documentos vinculados.';

  @override
  String get noLinks => 'Este documento no está vinculado a nada.';

  @override
  String get noMaintenance => 'No hay registros de mantenimiento';

  @override
  String get noMaintenanceHint =>
      'Añade un recibo de reparación o mantenimiento vinculado al objeto.';

  @override
  String get noMileage => 'No hay kilometraje registrado';

  @override
  String get noNotifications => 'No hay notificaciones nuevas';

  @override
  String get noRecordYet => 'Aún no hay registros.';

  @override
  String get noRecords => 'Aún no hay registros';

  @override
  String get noReminders => 'No hay recordatorios';

  @override
  String get noRemindersCta =>
      'Añade tu primer recordatorio: matriculación, garantía, contrato…';

  @override
  String get noRemindersHint =>
      'Los recordatorios te avisan a tiempo de los plazos importantes.';

  @override
  String get noResults => 'Sin resultados';

  @override
  String get noResultsFiltered => 'Ningún documento coincide con los filtros.';

  @override
  String get noResultsHint =>
      'Prueba otro término, borra los filtros o añade un documento.';

  @override
  String get noSharedDocs => 'No hay documentos compartidos.';

  @override
  String get noSharedDocsHint =>
      'Cambia la privacidad de un documento a «Familia» o «Seleccionados» para que otros lo vean.';

  @override
  String get noSuggestions => 'No hay sugerencias de la IA';

  @override
  String get noSuggestionsBody =>
      'Todavía no hay sugerencias para este documento.';

  @override
  String get noVehicles => 'Aún no hay vehículos';

  @override
  String get noVehiclesHint =>
      'Añade un vehículo para controlar el historial de mantenimiento, los gastos y los plazos.';

  @override
  String get noWarrantyDate =>
      'No se ha introducido la fecha de fin de la garantía';

  @override
  String get noWarrantyFound =>
      'No se ha encontrado información de garantía en el documento. No suponemos ningún periodo de garantía.';

  @override
  String get none => 'Ninguno';

  @override
  String get notAvailable => 'No disponible o sin acceso.';

  @override
  String get notSet => 'sin definir';

  @override
  String get notes => 'Notas';

  @override
  String get notificationChannels => 'Canales de notificación';

  @override
  String get notificationGenericBody =>
      'Tienes un recordatorio que requiere tu atención.';

  @override
  String get notificationTitle => 'Recordatorio de MyWorld+';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get notificationsAllowed => 'Las notificaciones están permitidas';

  @override
  String get notificationsBlocked => 'Las notificaciones no están permitidas';

  @override
  String get notifyBefore => 'Avisarme';

  @override
  String get offlineBanner =>
      'Sin conexión: los cambios se sincronizarán más tarde';

  @override
  String get onboarding1Body =>
      'Documentos, recibos, garantías, objetos, vehículos y familia, todo organizado.';

  @override
  String get onboarding1Title => 'Todo lo importante, en un solo lugar.';

  @override
  String get onboarding2Body => 'Hazle una foto y creamos un PDF limpio.';

  @override
  String get onboarding2Title =>
      'Guarda documentos, recibos y garantías en segundos.';

  @override
  String get onboarding3Body =>
      'Búsqueda rápida y recordatorios para los plazos importantes.';

  @override
  String get onboarding3Title =>
      'Encuentra lo que necesitas, justo cuando lo necesitas.';

  @override
  String get open => 'Abrir';

  @override
  String get openDocument => 'Abrir documento';

  @override
  String get openPreview => 'Abrir vista previa';

  @override
  String get openSourceLicenses => 'Licencias de código abierto';

  @override
  String get openingCamera => 'Abriendo la cámara…';

  @override
  String get optionalDetails => 'Datos adicionales (opcional)';

  @override
  String get orContinueWith => 'o';

  @override
  String get overdue => 'Vencido';

  @override
  String get ownerCannotLeave =>
      'El propietario no puede salir mientras queden otros miembros. Elimínalos primero.';

  @override
  String get pageNotFound => 'Esta página no existe.';

  @override
  String get password => 'Contraseña';

  @override
  String get passwordHelp => 'Al menos 8 caracteres, letras y números';

  @override
  String get passwordTooShort =>
      'La contraseña debe tener al menos 8 caracteres';

  @override
  String get passwordWeak => 'La contraseña debe contener letras y números';

  @override
  String get pendingInvites => 'Invitaciones pendientes';

  @override
  String get period => 'Periodo';

  @override
  String get permissionDeniedTitle => 'Sin acceso';

  @override
  String get permissionsExplainer =>
      'Los roles deciden quién gestiona la familia (invitaciones, perfiles). Un rol nunca da acceso a los documentos de otra persona: eso lo decide la privacidad de cada documento.';

  @override
  String get phonesOnePerLine => 'Teléfonos (uno por línea)';

  @override
  String get photos => 'Fotos';

  @override
  String get pin => 'PIN';

  @override
  String get pinHelp => 'De 4 a 8 dígitos';

  @override
  String get pinMismatch => 'Los PIN no coinciden';

  @override
  String get pinNew => 'Nuevo PIN';

  @override
  String get pinRepeat => 'Repetir PIN';

  @override
  String get planFamilyBase => 'Family Base';

  @override
  String get planFamilyPro => 'Family Pro';

  @override
  String get planFromFamily => 'Plan proporcionado por tu familia';

  @override
  String get planIndividualBase => 'Individual Base';

  @override
  String get planIndividualPro => 'Individual Pro';

  @override
  String get plansSubtitle =>
      'Elige el plan que más te convenga. Cámbialo o cancélalo cuando quieras.';

  @override
  String get plansTitle => 'Planes';

  @override
  String get price => 'Precio';

  @override
  String get privacy => 'Quién puede verlo';

  @override
  String get privacyBullets =>
      '• Todos los archivos son privados y solo se accede a ellos tras una comprobación en el servidor.\n• Los miembros de la familia solo ven lo que compartes de forma explícita.\n• El contenido de los documentos nunca se envía a estadísticas, registros ni redes publicitarias.\n• Eliminar tu cuenta elimina realmente los datos del servidor.';

  @override
  String get privacyFamily => 'Familia';

  @override
  String get privacyFamilyHelp =>
      'Todos los miembros activos de tu familia pueden verlo.';

  @override
  String get privacyNoFamilyHelp =>
      'Compartir está disponible cuando estás en una familia.';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get privacyPrivate => 'Privado';

  @override
  String get privacyPrivateHelp => 'Solo tú puedes verlo.';

  @override
  String get privacySettings => 'Privacidad';

  @override
  String get privacyShared => 'Seleccionados';

  @override
  String get privacySharedHelp =>
      'Solo los miembros que selecciones pueden verlo.';

  @override
  String get processingStatus => 'Estado del procesamiento';

  @override
  String get profile => 'Perfil';

  @override
  String get profileSetupBody =>
      'Solo un par de datos. No pedimos nada sensible.';

  @override
  String get profileSetupTitle => 'Tu perfil';

  @override
  String get purchaseDate => 'Fecha de compra';

  @override
  String get purchaseDetails => 'Compra';

  @override
  String get purchaseProcessed => 'Compra procesada. Actualizando tu plan…';

  @override
  String get reactivate => 'Reactivar';

  @override
  String get readCardWithAi => 'Leer tarjeta con IA';

  @override
  String get recFuel => 'Combustible';

  @override
  String get recInspection => 'Inspección técnica';

  @override
  String get recInsurance => 'Seguro';

  @override
  String get recOil => 'Cambio de aceite';

  @override
  String get recOther => 'Otro';

  @override
  String get recParking => 'Aparcamiento';

  @override
  String get recParts => 'Piezas';

  @override
  String get recRegistration => 'Matriculación';

  @override
  String get recRepair => 'Reparación';

  @override
  String get recService => 'Mantenimiento periódico';

  @override
  String get recTires => 'Neumáticos';

  @override
  String get recTolls => 'Peajes';

  @override
  String get receipts => 'Recibos';

  @override
  String get receiptsAndWarranties => 'Recibos y garantías';

  @override
  String get recentRecords => 'Registros recientes';

  @override
  String get recentlyAdded => 'Añadidos recientemente';

  @override
  String get recordType => 'Tipo de registro';

  @override
  String get refreshStatus => 'Actualizar estado de la suscripción';

  @override
  String get registrationInsurance => 'Matriculación y seguro';

  @override
  String get registrationNumber => 'Matrícula';

  @override
  String get relationshipOptional => 'Parentesco (opcional)';

  @override
  String get remindBeforeExpiry => 'Recordármelo antes de que caduque';

  @override
  String get reminder => 'Recordatorio';

  @override
  String get reminderSaved => 'Recordatorio guardado';

  @override
  String get reminderSettings => 'Ajustes de recordatorios';

  @override
  String get reminderType => 'Tipo';

  @override
  String get reminders => 'Recordatorios';

  @override
  String get removeAds => 'Quitar anuncios';

  @override
  String get removeFavorite => 'Quitar de favoritos';

  @override
  String get removeMember => 'Eliminar miembro';

  @override
  String get removeMemberBody =>
      'El miembro pierde de inmediato el acceso a los documentos familiares y compartidos. Sus propios documentos siguen siendo suyos.';

  @override
  String get renewsOn => 'Se renueva el';

  @override
  String get repeat => 'Repetir';

  @override
  String get repeatDaily => 'Cada día';

  @override
  String get repeatMonthly => 'Cada mes';

  @override
  String get repeatNone => 'No se repite';

  @override
  String get repeatWeekly => 'Cada semana';

  @override
  String get repeatYearly => 'Cada año';

  @override
  String get required => 'Obligatorio';

  @override
  String get resendEmail => 'Reenviar correo';

  @override
  String get resetPassword => 'Restablecer contraseña';

  @override
  String get resetPasswordBody =>
      'Introduce tu correo y te enviaremos un enlace para establecer una contraseña nueva.';

  @override
  String get resetSentBody =>
      'Si la cuenta existe, se ha enviado un enlace. Revisa también la carpeta de spam.';

  @override
  String get resetSentTitle => 'Revisa tu correo';

  @override
  String get restore => 'Restaurar';

  @override
  String get restoreDone => 'Compras comprobadas';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get restored => 'Restaurado';

  @override
  String get retake => 'Repetir';

  @override
  String get retry => 'Reintentar';

  @override
  String get reviewSuggestions => 'Revisar sugerencias de la IA';

  @override
  String get revoke => 'Revocar';

  @override
  String get roleAdmin => 'Administrador';

  @override
  String get roleMember => 'Miembro';

  @override
  String get roleOwner => 'Propietario';

  @override
  String get rotate => 'Girar';

  @override
  String get save => 'Guardar';

  @override
  String get saveAnyway => 'Guardar de todos modos';

  @override
  String get saveDocumentTitle => 'Guardar documento';

  @override
  String get saveToVault => 'Guardar en la caja fuerte';

  @override
  String get saveToVaultHelp =>
      'Para documentos personales especialmente importantes. Nunca se usan en las preguntas a la IA.';

  @override
  String get saved => 'Guardado';

  @override
  String get scanBarcode => 'Escanear código de barras / QR';

  @override
  String get scanBarcodeHelp => 'Apunta la cámara al código de barras o QR';

  @override
  String get scanReviewHelp =>
      'Revisa las páginas. Puedes girarlas, repetirlas, eliminarlas o arrastrarlas para cambiar el orden.';

  @override
  String get search => 'Buscar';

  @override
  String get searchCards => 'Buscar tarjetas';

  @override
  String get searchContacts => 'Buscar contactos';

  @override
  String get searchHint => '¿Qué buscas hoy?';

  @override
  String get searchItems => 'Buscar objetos';

  @override
  String get searchStartBody =>
      'Busca por nombre, categoría, vendedor, persona, dispositivo, importe o etiqueta.';

  @override
  String get searchStartTitle => 'Empieza a escribir';

  @override
  String get searchVault => 'Buscar en la caja fuerte';

  @override
  String get seeAll => 'Ver todo';

  @override
  String get seePlans => 'Ver planes';

  @override
  String get send => 'Enviar';

  @override
  String get sendLink => 'Enviar enlace';

  @override
  String get serialNumber => 'Número de serie';

  @override
  String get serviceHistory => 'Historial de mantenimiento';

  @override
  String get serviceOrVendor => 'Taller o vendedor';

  @override
  String get sessionExpiredBody => 'Por tu seguridad, vuelve a iniciar sesión.';

  @override
  String get sessionExpiredTitle => 'Sesión caducada';

  @override
  String get setPin => 'Establecer PIN de la caja fuerte';

  @override
  String get settings => 'Ajustes';

  @override
  String get share => 'Compartir';

  @override
  String get shareFile => 'Exportar archivo';

  @override
  String get sharedByMe => 'Compartidos por mí';

  @override
  String get sharedDocuments => 'Documentos compartidos';

  @override
  String get sharedWithMe => 'Compartidos conmigo';

  @override
  String get sharing => 'Compartir y privacidad';

  @override
  String get sharingNeedsFamily =>
      'Con los planes Family puedes compartir documentos con los miembros de la familia.';

  @override
  String get sharingServerNote =>
      'El acceso se comprueba en el servidor para cada documento y archivo. Cuando quitas el acceso a alguien, lo pierde de inmediato.';

  @override
  String get sharingUpdated => 'Uso compartido actualizado';

  @override
  String get showCompleted => 'Mostrar completados';

  @override
  String get showDetailsHelp =>
      'Desactivado: la pantalla de bloqueo solo indica que tienes un recordatorio. Activado: se muestra el título del recordatorio.';

  @override
  String get showDetailsInNotifications =>
      'Mostrar el título en la notificación';

  @override
  String get showPassword => 'Mostrar contraseña';

  @override
  String get showUsedExpired => 'Mostrar usados y caducados';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get signInTitle => 'Hola de nuevo';

  @override
  String get signInAsTester => 'Entrar como tester';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get signUpTitle => 'Crea tu MyWorld+';

  @override
  String get skip => 'Omitir';

  @override
  String get snoozeWeek => 'Posponer una semana';

  @override
  String get soon => 'Pronto';

  @override
  String get sortAmountAsc => 'Importe más bajo';

  @override
  String get sortAmountDesc => 'Importe más alto';

  @override
  String get sortBy => 'Ordenar por';

  @override
  String get sortExpiry => 'Fecha de caducidad';

  @override
  String get sortNameAsc => 'Nombre A–Z';

  @override
  String get sortNameDesc => 'Nombre Z–A';

  @override
  String get sortNewest => 'Más recientes';

  @override
  String get sortOldest => 'Más antiguos';

  @override
  String get source => 'Fuente';

  @override
  String get sources => 'Fuentes';

  @override
  String get startExport => 'Crear exportación';

  @override
  String get status => 'Estado';

  @override
  String get statusActive => 'Activo';

  @override
  String get statusCancelled => 'Cancelado';

  @override
  String get statusDiscarded => 'Descartado';

  @override
  String get statusDone => 'Hecho';

  @override
  String get statusDraft => 'Borrador';

  @override
  String get statusFailed => 'Error';

  @override
  String get statusInRepair => 'En reparación';

  @override
  String get statusNeedsReview => 'Requiere revisión';

  @override
  String get statusProcessing => 'Procesando';

  @override
  String get statusReady => 'Listo';

  @override
  String get statusRefreshed => 'Estado actualizado';

  @override
  String get statusSnoozed => 'Pospuesto';

  @override
  String get statusSold => 'Vendido';

  @override
  String get statusUploaded => 'Subido';

  @override
  String get statusUploading => 'Subiendo';

  @override
  String get storage => 'Almacenamiento';

  @override
  String get storageAlmostFull => 'El almacenamiento está casi lleno';

  @override
  String get subActive => 'Activa';

  @override
  String get subBillingIssue => 'Problema de pago';

  @override
  String get subCancelled => 'Cancelada: válida hasta el final del periodo';

  @override
  String get subExpired => 'Caducada';

  @override
  String get subNone => 'Plan gratuito';

  @override
  String get subRefunded => 'Reembolsada';

  @override
  String get subscriptionTerms =>
      'La suscripción se renueva cada mes hasta que la canceles en los ajustes de App Store o Google Play. El pago se carga en tu cuenta de la tienda.';

  @override
  String get summary => 'Resumen';

  @override
  String get supportPrivacyNote =>
      'Nunca envíes contraseñas ni el contenido de documentos al soporte.';

  @override
  String get tagline => 'Tu vida. En un solo lugar.';

  @override
  String get tags => 'Etiquetas';

  @override
  String get takePhoto => 'Hacer foto';

  @override
  String get termsOfUse => 'Términos de uso';

  @override
  String get thisYear => 'Este año';

  @override
  String get timezone => 'Zona horaria';

  @override
  String get title => 'Título';

  @override
  String get today => 'Hoy';

  @override
  String get tomorrow => 'Mañana';

  @override
  String get totalInvested => 'Total invertido';

  @override
  String get totalValue => 'Valor total';

  @override
  String get trash => 'Papelera';

  @override
  String get trashEmpty => 'La papelera está vacía';

  @override
  String get trashRetention =>
      'Los documentos de la papelera se eliminan definitivamente a los 30 días.';

  @override
  String get tryAi => 'Preguntar a la IA';

  @override
  String get typeDeleteToConfirm => 'Escribe ELIMINAR para confirmar';

  @override
  String get unlock => 'Desbloquear';

  @override
  String get unlockVaultReason => 'Desbloquear la caja fuerte';

  @override
  String get upcomingDeadlines => 'Próximos plazos';

  @override
  String get upgradeAiBody =>
      'La IA lee recibos, sugiere categorías y recordatorios, y responde a preguntas sobre tus datos, con fuentes.';

  @override
  String get upgradeAiTitle => 'La ayuda de la IA está en los planes Pro';

  @override
  String get upgradeDocumentsBody =>
      'Has alcanzado el número de documentos del plan gratuito. No se elimina nada: elige un plan mayor para tener más espacio.';

  @override
  String get upgradeDocumentsTitle => 'Límite de documentos';

  @override
  String get upgradeExportBody =>
      'La exportación CSV forma parte de los planes Pro.';

  @override
  String get upgradeExportTitle => 'Exportación avanzada';

  @override
  String get upgradeFamilyBody =>
      'El espacio familiar, las invitaciones y compartir documentos están disponibles en Family Base y Family Pro.';

  @override
  String get upgradeFamilyTitle => 'Plan Family';

  @override
  String get upgradeFiltersBody =>
      'Los filtros por estado de procesamiento y la búsqueda avanzada están en los planes de pago.';

  @override
  String get upgradeFiltersTitle => 'Filtros avanzados';

  @override
  String get upgradeStorageBody =>
      'No se ha eliminado nada. Elige un plan mayor o libera espacio.';

  @override
  String get upgradeStorageTitle => 'El almacenamiento está lleno';

  @override
  String get upgradeVehiclesBody =>
      'Tu plan permite un número limitado de vehículos. Un plan mayor permite más.';

  @override
  String get upgradeVehiclesTitle => 'Límite de vehículos';

  @override
  String get uploadErrorTitle => 'Error al subir';

  @override
  String get uploadFailedHint =>
      'El archivo no se ha subido o no ha superado la validación. Vuelve a subirlo.';

  @override
  String get uploadKeepOpen =>
      'Mantén la app abierta hasta que termine la subida.';

  @override
  String get useBiometrics => 'Usar biometría';

  @override
  String get useRegularSearch => 'Usar la búsqueda normal';

  @override
  String get validFrom => 'Válido desde';

  @override
  String get vaultEmpty => 'La caja fuerte está vacía';

  @override
  String get vaultEmptyBody =>
      'Guarda aquí documentos personales, contratos, pólizas y certificados.';

  @override
  String get vaultLockDisclaimer =>
      'El PIN y la biometría añaden protección al abrir la caja fuerte en este dispositivo. No es cifrado: tus archivos están protegidos por comprobaciones de acceso en el servidor, independientemente del PIN.';

  @override
  String get vaultLocked => 'La caja fuerte está bloqueada';

  @override
  String get vaultLockedBody => 'Introduce tu PIN o usa la biometría.';

  @override
  String get vaultSettings => 'Ajustes de la caja fuerte';

  @override
  String get vaultSubtitle =>
      'Documentos privados y especialmente importantes. Aquí no hay anuncios.';

  @override
  String get vendor => 'Vendedor';

  @override
  String get verifyEmailTitle => 'Verifica tu correo';

  @override
  String get warrantiesExpiring => 'Garantías que vencen';

  @override
  String get warranty => 'Garantía';

  @override
  String get warrantyConfirm => 'Confirmo la fecha de la garantía';

  @override
  String get warrantyConfirmHelp =>
      'Revisa el certificado de garantía. La garantía nunca se establece sin tu confirmación.';

  @override
  String get warrantyFieldHelp =>
      'Rellénalo solo si figura en el certificado de garantía';

  @override
  String get warrantySuggestion => 'Sugerencia del documento';

  @override
  String get warrantyUntil => 'Garantía hasta';

  @override
  String get warrantyUserEnteredNote =>
      'La fecha de garantía es la que has introducido o confirmado.';

  @override
  String get website => 'Sitio web';

  @override
  String get welcome => 'Te damos la bienvenida';

  @override
  String get withReminder => 'Con recordatorio';

  @override
  String get withWarranty => 'Con garantía';

  @override
  String get worldSubtitle => 'Cada área de tu vida';

  @override
  String get year => 'Año';

  @override
  String get you => 'tú';

  @override
  String addDocumentFor(String name) {
    return 'Documento para $name';
  }

  @override
  String cardExpiresTitle(String name) {
    return 'La tarjeta caduca: $name';
  }

  @override
  String cardsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tarjetas',
      one: '$count tarjeta',
      zero: 'Sin tarjetas',
    );
    return '$_temp0';
  }

  @override
  String cardsExpiringSoon(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tarjetas caducan en las próximas 2 semanas',
      one: '$count tarjeta caduca en las próximas 2 semanas',
    );
    return '$_temp0';
  }

  @override
  String contactsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count contactos',
      one: '$count contacto',
      zero: 'Sin contactos',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hace $count días',
      one: 'hace $count día',
    );
    return '$_temp0';
  }

  @override
  String daysBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días antes',
      one: '$count día antes',
    );
    return '$_temp0';
  }

  @override
  String documentExpiresTitle(String title) {
    return 'Caduca: $title';
  }

  @override
  String documentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count documentos',
      one: '$count documento',
      zero: 'Sin documentos',
    );
    return '$_temp0';
  }

  @override
  String documentsUsed(int used, int limit) {
    return 'Documentos: $used de $limit';
  }

  @override
  String duplicateBody(String title) {
    return 'El mismo archivo ya está guardado como «$title». ¿Guardarlo otra vez?';
  }

  @override
  String expiresOn(String date) {
    return 'Caduca el $date';
  }

  @override
  String featureDocuments(String count) {
    return 'Hasta $count documentos';
  }

  @override
  String featureMembers(int count) {
    return 'Hasta $count miembros de la familia';
  }

  @override
  String featureStorage(String size) {
    return '$size de almacenamiento';
  }

  @override
  String helloName(String name) {
    return 'Hola, $name';
  }

  @override
  String hoursBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count horas antes',
      one: '$count hora antes',
    );
    return '$_temp0';
  }

  @override
  String inDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'en $count días',
      one: 'en $count día',
    );
    return '$_temp0';
  }

  @override
  String invitationBody(String name) {
    return '$name te invita a su espacio familiar. Aceptar no te da acceso a todos los documentos: solo ves lo que los demás comparten contigo.';
  }

  @override
  String inviteShareText(String link) {
    return 'Únete a nuestra familia en MyWorld+: $link';
  }

  @override
  String invitedTo(String name) {
    return 'Invitación a «$name»';
  }

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count objetos',
      one: '$count objeto',
      zero: 'Sin objetos',
    );
    return '$_temp0';
  }

  @override
  String joinedOn(String date) {
    return 'Miembro desde el $date';
  }

  @override
  String last12Months(String currency) {
    return 'Últimos 12 meses $currency';
  }

  @override
  String lastOn(String date) {
    return 'Último: $date';
  }

  @override
  String membersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count miembros',
      one: '$count miembro',
    );
    return '$_temp0';
  }

  @override
  String minutesBefore(int count) {
    return '$count min antes';
  }

  @override
  String nextDue(String date) {
    return 'Próximo: $date';
  }

  @override
  String offerReminderBody(String date) {
    return '¿Quieres un recordatorio para el $date?';
  }

  @override
  String pageN(int n) {
    return 'Página $n';
  }

  @override
  String pagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count páginas',
      one: '$count página',
    );
    return '$_temp0';
  }

  @override
  String pricePerMonth(String price) {
    return '$price € / mes';
  }

  @override
  String purchasedOn(String date) {
    return 'Comprado el $date';
  }

  @override
  String remindersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recordatorios',
      one: '$count recordatorio',
      zero: 'Sin recordatorios',
    );
    return '$_temp0';
  }

  @override
  String removeMemberTitle(String name) {
    return '¿Eliminar a $name?';
  }

  @override
  String reviewIntro(int percent) {
    return 'La IA ha leído el documento (confianza del $percent %). Revisa y corrige los datos antes de guardar.';
  }

  @override
  String reviewNeededFor(String title) {
    return 'Revisar sugerencias: $title';
  }

  @override
  String scanReviewTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count páginas',
      one: '$count página',
    );
    return '$_temp0';
  }

  @override
  String sharedBy(String name) {
    return 'Compartido por $name';
  }

  @override
  String storageUsed(String used, String total) {
    return '$used de $total usados';
  }

  @override
  String uploadProgress(int percent) {
    return 'Subiendo… $percent %';
  }

  @override
  String validUntil(String date) {
    return 'Válido hasta el $date';
  }

  @override
  String vehiclesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vehículos',
      one: '$count vehículo',
      zero: 'Sin vehículos',
    );
    return '$_temp0';
  }

  @override
  String verifyEmailBody(String email) {
    return 'Hemos enviado un enlace a $email. Ábrelo para confirmar tu cuenta.';
  }

  @override
  String warrantyActiveUntil(String date) {
    return 'Garantía válida hasta el $date';
  }

  @override
  String warrantyDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Quedan $count días de garantía',
      one: 'Queda $count día de garantía',
    );
    return '$_temp0';
  }

  @override
  String warrantyExpiredOn(String date) {
    return 'La garantía venció el $date';
  }

  @override
  String warrantyExpiresTitle(String name) {
    return 'La garantía vence: $name';
  }

  @override
  String warrantyPrintedMonths(int months) {
    return 'En el documento: $months meses de garantía';
  }

  @override
  String warrantyPrintedUntil(String date) {
    return 'En el documento: hasta el $date';
  }

  @override
  String warrantyUntilShort(String date) {
    return 'Garantía hasta el $date';
  }

  @override
  String willBeSavedIn(String destination) {
    return 'Se guardará en: $destination';
  }

  @override
  String wrongPin(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'PIN incorrecto. Te quedan $count intentos.',
      one: 'PIN incorrecto. Te queda $count intento.',
    );
    return '$_temp0';
  }

  @override
  String get suggestedLinks => 'Vínculos sugeridos';

  @override
  String get suggestedLinksHelp =>
      'Hemos encontrado elementos que coinciden con este documento. Marca los que quieras vincular.';
}

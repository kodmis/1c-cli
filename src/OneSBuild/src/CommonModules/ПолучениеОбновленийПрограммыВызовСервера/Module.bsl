///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Получение обновлений программы".
// ОбщийМодуль.ПолучениеОбновленийПрограммыВызовСервера.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Функция ИнформацияОДоступномОбновлении() Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПараметрыКлиента", ИнтернетПоддержкаПользователей.ПараметрыКлиента());
	ДополнительныеПараметры.Вставить("НастройкиСоединения", ИнтернетПоддержкаПользователей.НастройкиСоединенияССерверами());
	ИнформацияОбОбновлении = ПолучениеОбновленийПрограммы.ИнформацияОДоступномОбновлении();
	
	Результат = Новый Структура;
	Результат.Вставить("Ошибка"            , Не ПустаяСтрока(ИнформацияОбОбновлении.ИмяОшибки));
	Результат.Вставить("Сообщение"         , ИнформацияОбОбновлении.Сообщение);
	Результат.Вставить("ИнформацияОбОшибке", ИнформацияОбОбновлении.ИнформацияОбОшибке);
	Результат.Вставить("ДоступноОбновление", ИнформацияОбОбновлении.ДоступноОбновление);
	
	Конфигурация = Новый Структура;
	Конфигурация.Вставить("Версия"                    , "");
	Конфигурация.Вставить("МинимальнаяВерсияПлатформы", "");
	Конфигурация.Вставить("РазмерОбновления"          , 0);
	Конфигурация.Вставить("URLНовоеВВерсии"           , "");
	Конфигурация.Вставить("URLПорядокОбновления"      , "");
	Если ИнформацияОбОбновлении.Конфигурация <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(Конфигурация, ИнформацияОбОбновлении.Конфигурация);
	КонецЕсли;
	Результат.Вставить("Конфигурация", Конфигурация);
	
	Платформа = Новый Структура;
	Платформа.Вставить("Версия"                 , "");
	Платформа.Вставить("РазмерОбновления"       , 0);
	Платформа.Вставить("URLОсобенностиПерехода" , "");
	Платформа.Вставить("URLСтраницыПлатформы"   , "");
	Платформа.Вставить("ОбязательностьУстановки", 0);
	ЗаполнитьЗначенияСвойств(Платформа, ИнформацияОбОбновлении.Платформа);
	Результат.Вставить("Платформа", Платформа);
	
	ИсправленияДляТекущейВерсии = 0;
	ИсправленияДляНовойВерсии   = 0;
	Если ИнформацияОбОбновлении.Исправления <> Неопределено Тогда
		ИсправленияДляНовойВерсии = ИнформацияОбОбновлении.Исправления.НайтиСтроки(Новый Структура("ДляНовойВерсии", Истина)).Количество();
		ИсправленияДляТекущейВерсии = ИнформацияОбОбновлении.Исправления.НайтиСтроки(Новый Структура("ДляТекущейВерсии", Истина)).Количество();
	КонецЕсли;
	
	Результат.Вставить("ИсправленияДляТекущейВерсии", ИсправленияДляТекущейВерсии);
	Результат.Вставить("ИсправленияДляНовойВерсии"  , ИсправленияДляНовойВерсии);
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаписатьОшибкуВЖурналРегистрации(Знач СообщениеОбОшибке) Экспорт
	
	ПолучениеОбновленийПрограммы.ЗаписатьОшибкуВЖурналРегистрации(
		СообщениеОбОшибке);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Настройки автоматического обновления.

Функция НастройкиОбновления() Экспорт
	
	Возврат ПолучениеОбновленийПрограммы.НастройкиАвтоматическогоОбновления();
	
КонецФункции

Процедура ЗаписатьНастройкиОбновления(Знач Настройки) Экспорт
	
	ПолучениеОбновленийПрограммы.ЗаписатьНастройкиАвтоматическогоОбновления(Настройки);
	
КонецПроцедуры

Процедура ВключитьОтключитьАвтоматическуюУстановкуИсправлений(Знач ЗначениеНастройки) Экспорт
	
	ПолучениеОбновленийПрограммы.ВключитьОтключитьАвтоматическуюУстановкуИсправлений(
		ЗначениеНастройки);
	
КонецПроцедуры

Функция РасписаниеЗаданияУстановкиИсправлений() Экспорт
	
	Задание = РегламентныеЗаданияСервер.ПолучитьРегламентноеЗадание(
		Метаданные.РегламентныеЗадания.ПолучениеИУстановкаИсправленийКонфигурации);
	Если Задание <> Неопределено Тогда
		Возврат Задание.Расписание;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Процедура УстановитьРасписаниеЗаданияУстановкиИсправлений(Знач Расписание) Экспорт
	
	ПериодПовтораВТечениеДня = Расписание.ПериодПовтораВТечениеДня;
	Если ПериодПовтораВТечениеДня > 0 И ПериодПовтораВТечениеДня < 3600 Тогда
		ВызватьИсключение НСтр("ru = 'Интервал автоматической установки не может быть чаще, чем один раз в час.'");
	КонецЕсли;
	
	РегламентныеЗаданияСервер.УстановитьРасписаниеРегламентногоЗадания(
		Метаданные.РегламентныеЗадания.ПолучениеИУстановкаИсправленийКонфигурации,
		Расписание);
	
КонецПроцедуры

Процедура АвтоматическаяПроверкаОбновленийПриИзменении(НастройкиОбновления)  Экспорт
	
	ЗаписатьНастройкиОбновления(НастройкиОбновления);
	
	// Если пользовать имеет право на настройку в панели администрирования,
	// ему должны быть доступны все действия.
	УстановитьПривилегированныйРежим(Истина);
	
	// Очистка пользовательских настроек.
	Если НастройкиОбновления.РежимАвтоматическойПроверкиНаличияОбновленийПрограммы = 0 Тогда
		СписокПользователей = ПользователиИнформационнойБазы.ПолучитьПользователей();
		Для Каждого ТекПользователь Из СписокПользователей Цикл
			ОбщегоНазначения.ХранилищеОбщихНастроекУдалить(
				"ИнтеррнетПоддержка",
				"ПолучениеОбновленийПрограммы/ИнформацияОДоступномОбновлении"
					+ ?(ПолучениеОбновленийПрограммыКлиентСервер.Это64РазрядноеПриложение(),
					"64",
					""),
				ТекПользователь.Имя);
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Проверка версии платформы 1С:Предприятие при начале работы программы.

Функция ПараметрыПроверкиВерсииПлатформыПриЗапуске() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Продолжить"             , Ложь);
	Результат.Вставить("ЭтоАдминистраторСистемы", Пользователи.ЭтоПолноправныйПользователь(, Истина, Ложь));
	
	ПараметрыБазовойФункциональности = ОбщегоНазначения.ОбщиеПараметрыБазовойФункциональности();
	
	ТекущаяВерсияПлатформы       = ИнтернетПоддержкаПользователей.ТекущаяВерсияПлатформы1СПредприятие();
	МинимальнаяВерсияПлатформы   = ПараметрыБазовойФункциональности.МинимальнаяВерсияПлатформы;
	РекомендуемаяВерсияПлатформы = ПараметрыБазовойФункциональности.РекомендуемаяВерсияПлатформы;
	
	РаботаВПрограммеЗапрещена = (ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ТекущаяВерсияПлатформы, МинимальнаяВерсияПлатформы) < 0);
	
	// Определение необходимости отображения сообщения.
	Если Не РаботаВПрограммеЗапрещена Тогда
		
		Если Не Результат.ЭтоАдминистраторСистемы Тогда
			
			// Если работа в программе разрешена, тогда не показывать
			// сообщение обычному пользователю.
			Результат.Продолжить = Истина;
			Возврат Результат;
			
		Иначе
			
			// Проверить необходимость показа оповещения администратору.
			НастройкиОповещения = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
				"ИнтеррнетПоддержка_ПолучениеОбновленийПрограммы",
				"СообщениеОНерекомендуемойВерсииПлатформы");
			
			Если ТипЗнч(НастройкиОповещения) = Тип("Структура")
				И НастройкиОповещения.Свойство("МетаданныеИмя")
				И НастройкиОповещения.Свойство("МетаданныеВерсия")
				И ИнтернетПоддержкаПользователей.ИмяКонфигурации() =
					НастройкиОповещения.МетаданныеИмя
				И ИнтернетПоддержкаПользователей.ВерсияКонфигурации() =
					НастройкиОповещения.МетаданныеВерсия  Тогда
				
				// Если сообщение уже отображалось для текущего набора
				// свойств метаданных, тогда пропустить отображение сообщения.
				Результат.Продолжить = Истина;
				Возврат Результат;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Определение параметров отображения оповещения.
	Результат.Вставить("РаботаВПрограммеЗапрещена",
		ПараметрыБазовойФункциональности.РаботаВПрограммеЗапрещена);
	
	ТекстСообщения = "<body>" + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Для работы с программой %1 использовать версию платформы &quot;1С:Предприятие 8&quot; не ниже: <b>%2</b>
			|<br />Используемая сейчас версия: %3'"),
		?(ПараметрыБазовойФункциональности.РаботаВПрограммеЗапрещена,
			НСтр("ru = 'необходимо'"),
			НСтр("ru = 'рекомендуется'")),
		?(РаботаВПрограммеЗапрещена, МинимальнаяВерсияПлатформы, РекомендуемаяВерсияПлатформы),
		ТекущаяВерсияПлатформы);
	
	Если Не Результат.ЭтоАдминистраторСистемы Тогда
		
		// В этой ветви работа в программе запрещена.
		ТекстСообщения = ТекстСообщения + "<br /><br />"
			+ НСтр("ru = 'Вход в программу невозможен.<br />
				|Необходимо обратиться к администратору для обновления версии платформы 1С:Предприятие.'");
		
	ИначеЕсли ПараметрыБазовойФункциональности.РаботаВПрограммеЗапрещена Тогда
		
		ТекстСообщения = ТекстСообщения + "<br /><br />"
			+ НСтр("ru = 'Вход в программу невозможен.<br />
				|Необходимо предварительно обновить версию платформы 1С:Предприятие.'");
		
	Иначе
		
		ТекстСообщения = ТекстСообщения + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"<br /><br />"
				+ НСтр("ru='Рекомендуется обновить версию платформы 1С:Предприятия. Новая версия платформы содержит исправления ошибок,
					|которые позволят программе работать более стабильно.
					|<br />
					|<br />
					|Вы также можете продолжить работу на текущей версии платформы %1
					|<br />
					|<br />
					|<i>Версия платформы, необходимая для работы в программе: %2, рекомендуемая: %3 или выше, текущая: %4.</i>'"),
			ТекущаяВерсияПлатформы,
			МинимальнаяВерсияПлатформы,
			РекомендуемаяВерсияПлатформы,
			ТекущаяВерсияПлатформы);
		
	КонецЕсли;
	
	ТекстСообщения = ТекстСообщения + "</body>";
	Результат.Вставить("ТекстСообщения",
		ИнтернетПоддержкаПользователейКлиентСервер.ФорматированныйЗаголовок(ТекстСообщения));
	
	Возврат Результат;
	
КонецФункции

Процедура СохранитьНастройкиОповещенияОНерекомендуемойВерсииПлатформы() Экспорт
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"ИнтеррнетПоддержка_ПолучениеОбновленийПрограммы",
		"СообщениеОНерекомендуемойВерсииПлатформы",
		Новый Структура(
			"МетаданныеИмя, МетаданныеВерсия",
			ИнтернетПоддержкаПользователей.ИмяКонфигурации(),
			ИнтернетПоддержкаПользователей.ВерсияКонфигурации()));
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Проверка наличия обновлений в фоновом режиме.

Функция НачатьПроверкуНаличияОбновления() Экспорт
	
	Если Не ПолучениеОбновленийПрограммы.ДоступноИспользованиеОбновленияПрограммы() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Попытка
		
		ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор);
		ПараметрыВыполнения.ЗапуститьВФоне      = Истина;
		ПараметрыВыполнения.ОжидатьЗавершение   = 0;
		ПараметрыВыполнения.КлючФоновогоЗадания = "ПроверкаНаличияОбновленийПрограммы_" + Строка(Новый УникальныйИдентификатор);
		
		ПараметрыПроцедуры = Новый Структура;
		ПараметрыПроцедуры.Вставить("ПараметрыКлиента", ИнтернетПоддержкаПользователей.ПараметрыКлиента());
		
		Результат = ДлительныеОперации.ВыполнитьВФоне(
			"ПолучениеОбновленийПрограммы.ПроверитьНаличиеОбновленияВФоновомРежиме",
			ПараметрыПроцедуры,
			ПараметрыВыполнения);
		
		Если Результат.Статус = "Отменено" Тогда
			
			ПолучениеОбновленийПрограммы.ЗаписатьИнформациюВЖурналРегистрации(
				НСтр("ru = 'Не удалось выполнить фоновую проверку наличия обновлений. Задание отменено администратором.'"));
			Возврат Неопределено;
			
		ИначеЕсли Результат.Статус = "Ошибка" Тогда
			
			ПолучениеОбновленийПрограммы.ЗаписатьОшибкуВЖурналРегистрации(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Ошибка фоновой проверки наличия обновлений. Не удалось выполнить фоновое задание. %1'"),
					Результат.ПодробноеПредставлениеОшибки));
			Возврат Неопределено;
			
		ИначеЕсли Результат.Статус = "Выполнено" Тогда
			
			Возврат Новый Структура("Идентификатор, АдресРезультата, Выполнено",
				Результат.ИдентификаторЗадания,
				Результат.АдресРезультата,
				Истина);
			
		Иначе
			
			Возврат Новый Структура("Идентификатор, АдресРезультата, Выполнено",
				Результат.ИдентификаторЗадания,
				Результат.АдресРезультата,
				Ложь);
			
		КонецЕсли;
		
	Исключение
		
		ПолучениеОбновленийПрограммы.ЗаписатьОшибкуВЖурналРегистрации(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка фоновой проверки наличия обновлений. Не удалось выполнить фоновое задание. %1'"),
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())));
		Возврат Неопределено;
		
	КонецПопытки;
	
КонецФункции

Функция РезультатЗаданияПроверкиНаличияОбновлений(Знач ОписаниеЗадания) Экспорт
	
	Попытка
		ЗаданиеВыполнено = ДлительныеОперации.ЗаданиеВыполнено(ОписаниеЗадания.Идентификатор);
	Исключение
		ПолучениеОбновленийПрограммы.ЗаписатьОшибкуВЖурналРегистрации(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось определить результат фоновой проверки наличия обновлений. %1'"),
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())));
		Возврат -1;
	КонецПопытки;
	
	Если Не ЗаданиеВыполнено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ОпределитьПараметрыОповещенияОДоступномОбновлении(ОписаниеЗадания);
	
КонецФункции

Функция ОпределитьПараметрыОповещенияОДоступномОбновлении(ОписаниеЗадания) Экспорт
	
	Результат = ПолучитьИзВременногоХранилища(ОписаниеЗадания.АдресРезультата);
	ПолучениеОбновленийПрограммы.СохранитьИнформациюОДоступномОбновленииВНастройках(Результат);
	ПараметрыОповещения = ПолучениеОбновленийПрограммы.ПараметрыОповещенияОДоступномОбновлении(Результат);
	Если ПараметрыОповещения = Неопределено Тогда
		Возврат -1;
	Иначе
		Возврат ПараметрыОповещения;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

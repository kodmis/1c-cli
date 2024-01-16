///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интернет-поддержка пользователей".
// ОбщийМодуль.КлиентЛицензирования.
//
// Серверные процедуры и функции настройки клиента лицензирования.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Возвращается имя клиента лицензирования.
//
Функция ИмяКлиентаЛицензирования() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат ПолучитьИмяКлиентаЛицензирования();
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Определяет идентификатор конфигурации.
//
// Возвращаемое значение:
//  Строка - идентификатор конфигурации.
//
Функция ИДКонфигурации() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат ПолучитьИдентификаторКонфигурации();
	
КонецФункции

#Область НастройкиКлиентаЛицензирования

// Проверяет соответствие настроек клиента лицензирования данным аутентификации
// Интернет-поддержки.
// При несоответствии настроек логин и пароль ИПП записываются в настройки
// клиента лицензирования.
// Не используется при работе в модели сервиса.
//
// Возвращаемое значение:
//  Булево - Истина, если пользователю необходимо ввести логин и пароль,
//           Ложь - в противном случае.
//
Функция ПроверитьНастройкиКлиентаЛицензирования() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДанныеАутентификации = ИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
	Если ДанныеАутентификации = Неопределено
		И ОбновлениеИнформационнойБазы.ВыполняетсяОбновлениеИнформационнойБазы() Тогда
		// Если информационная база еще не обновлена, тогда
		// настройки параметров ИПП могут быть еще не перенесены
		// в безопасное хранилище данных.
		ДанныеАутентификации = ДанныеАутентификацииПользователяИнтернетПоддержкиИзУстаревшихДанных();
	КонецЕсли;
	
	Если ДанныеАутентификации = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Записать настройки клиента лицензирования в ИБ
	Если ИмяКлиентаЛицензирования() = ДанныеАутентификации.Логин Тогда
		// Логин совпадает, некорректный пароль пользователя, необходимо потребовать от
		// пользователя повторный ввод логина и пароля.
		Возврат Ложь;
	Иначе
		
		ЗаписатьДанныеАутентификацииВНастройкиКлиентаЛицензирования(ДанныеАутентификации.Логин, ДанныеАутентификации.Пароль);
		Возврат Истина;
		
	КонецЕсли;
	
КонецФункции

// Записывает настройки клиента лицензирования.
//
// Параметры:
//  Логин - Строка - логин пользователя Интернет-поддержки;
//  Пароль - Строка - пароль пользователя Интернет-поддержки.
//
Процедура ЗаписатьДанныеАутентификацииВНастройкиКлиентаЛицензирования(Логин, Пароль)
	
	НастройкиПодключения = ИнтернетПоддержкаПользователейСлужебныйПовтИсп.НастройкиСоединенияССерверамиИПП();
	
	УстановитьНастройкиКлиентаЛицензирования(
		Логин,
		Пароль,
		ЗначениеДопПараметра(НастройкиПодключения.ДоменРасположенияСерверовИПП));
	
КонецПроцедуры

// Определяет значение дополнительного параметра
// настроек клиента лицензирования.
//
// Параметры:
//  ДоменнаяЗона - Число - идентификатор доменной зоны.
//
// Возвращаемое значение:
//  Строка - дополнительный параметр.
//
Функция ЗначениеДопПараметра(ДоменнаяЗона)
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		"domain=%1;",
		?(ДоменнаяЗона = 0, "ru", "eu"));
	
КонецФункции

// Обновление параметров клиента лицензирования.
//
Процедура ОбновитьЗначениеДополнительногоПараметраКлиентаЛицензирования()
	
	Попытка
		
		Если Пользователи.ЭтоПолноправныйПользователь(, Истина, Ложь) Тогда
			УстановитьПривилегированныйРежим(Истина);
			ДоменнаяЗона = ИнтернетПоддержкаПользователейСлужебныйПовтИсп.НастройкиСоединенияССерверамиИПП().ДоменРасположенияСерверовИПП;
			НовоеЗначениеДопПараметра = ЗначениеДопПараметра(ДоменнаяЗона);
			Если ПолучитьДополнительныйПараметрКлиентаЛицензирования() <> НовоеЗначениеДопПараметра Тогда
				УстановитьНастройкиКлиентаЛицензирования(, , НовоеЗначениеДопПараметра);
			КонецЕсли;
			УстановитьПривилегированныйРежим(Ложь);
		КонецЕсли;
		
	Исключение
		
		ИнтернетПоддержкаПользователей.ЗаписатьИнформациюВЖурналРегистрации(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось обновить значение дополнительного параметра в настройках клиента лицензирования.
					|%1'"),
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())));
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработкаСобытийБиблиотеки

// Вызывается при изменении данных аутентификации БИП.
//
// Параметры:
//  Логин - Строка - логин пользователя Интернет-поддержки;
//  Пароль - Строка - пароль пользователя Интернет-поддержки.
//
Процедура ПриИзмененииДанныхАутентификации(Логин, Пароль) Экспорт
	
	ЗаписатьДанныеАутентификацииВНастройкиКлиентаЛицензирования(Логин, Пароль);
	
КонецПроцедуры

// См. ИнтернетПоддержкаПользователей.ПередНачаломРаботыСистемы.
//
Процедура ПередНачаломРаботыСистемы() Экспорт
	
	ОбновитьЗначениеДополнительногоПараметраКлиентаЛицензирования();
	
КонецПроцедуры

#КонецОбласти

#Область ПолучениеДанныхИзУстаревшихОбъектовМетаданных

// Определяет данные аутентификации из регистра сведений УдалитьПараметрыИнтернетПоддержкиПользователей.
//
// Возвращаемое значение:
//  Структура - данные аутентификации:
//    *Логин - Строка - логин пользователя Интернет-поддержки;
//    *Пароль - Строка - пароль пользователя Интернет-поддержки.
//
Функция ДанныеАутентификацииПользователяИнтернетПоддержкиИзУстаревшихДанных()
	
	ЗапросПараметров = Новый Запрос(
	"ВЫБРАТЬ
	|	ПараметрыИнтернетПоддержкиПользователей.Имя КАК ИмяПараметра,
	|	ПараметрыИнтернетПоддержкиПользователей.Значение КАК ЗначениеПараметра
	|ИЗ
	|	РегистрСведений.УдалитьПараметрыИнтернетПоддержкиПользователей КАК ПараметрыИнтернетПоддержкиПользователей
	|ГДЕ
	|	ПараметрыИнтернетПоддержкиПользователей.Имя В (""login"", ""password"")
	|	И ПараметрыИнтернетПоддержкиПользователей.Пользователь = &ПустойИдентификатор");
	
	ЗапросПараметров.УстановитьПараметр("ПустойИдентификатор",
		Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	
	
	ЛогинПользователя  = Неопределено;
	ПарольПользователя = Неопределено;
	
	УстановитьПривилегированныйРежим(Истина);
	ВыборкаПараметров = ЗапросПараметров.Выполнить().Выбрать();
	Пока ВыборкаПараметров.Следующий() Цикл
		
		// В запросе регистр символов не учитывается
		ИмяПараметраНРег = НРег(ВыборкаПараметров.ИмяПараметра);
		Если ИмяПараметраНРег = "login" Тогда
			ЛогинПользователя = ВыборкаПараметров.ЗначениеПараметра;
			
		ИначеЕсли ИмяПараметраНРег = "password" Тогда
			ПарольПользователя = ВыборкаПараметров.ЗначениеПараметра;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЛогинПользователя <> Неопределено И ПарольПользователя <> Неопределено Тогда
		Возврат Новый Структура("Логин, Пароль", ЛогинПользователя, ПарольПользователя);
	Иначе
		// Данные не найдены в устаревшем регистре сведений - проверить
		// наличие данных в устаревшем безопасном хранилище данных.
		Возврат ДанныеАутентификацииВУстаревшемБезопасномХранилище();
	КонецЕсли;
	
КонецФункции

// Определяет данные аутентификации из безопасного хранилища.
//
// Возвращаемое значение:
//  Структура - данные аутентификации:
//    *Логин - Строка - логин пользователя Интернет-поддержки;
//    *Пароль - Строка - пароль пользователя Интернет-поддержки.
//
Функция ДанныеАутентификацииВУстаревшемБезопасномХранилище()
	
	Попытка
		ИдентификаторПодсистемыБИПУстаревший =
			ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
				"Подсистема.ИнтернетПоддержкаПользователей.Подсистема.БазоваяФункциональностьБИП");
	Исключение
		// Очень редкий случай. На момент вызова функции еще не обновлены
		// идентификаторы объектов метаданных в базовой функциональности БСП.
		ИнтернетПоддержкаПользователей.ЗаписатьИнформациюВЖурналРегистрации(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при получении данных аутентификации из устаревшего безопасного хранилища данных.
					|%1'"),
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())));
		Возврат Неопределено;
	КонецПопытки;
	
	ДанныеВБезопасномХранилищеУстаревшие =
		ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(
			ИдентификаторПодсистемыБИПУстаревший,
			"login,password");
	Если ДанныеВБезопасномХранилищеУстаревшие.login <> Неопределено
		И ДанныеВБезопасномХранилищеУстаревшие.password <> Неопределено Тогда
		Возврат Новый Структура(
			"Логин, Пароль",
			ДанныеВБезопасномХранилищеУстаревшие.login,
			ДанныеВБезопасномХранилищеУстаревшие.password);
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#КонецОбласти

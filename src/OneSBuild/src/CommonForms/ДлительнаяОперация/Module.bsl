///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ФормаЗакрывается;

&НаКлиенте
Перем СтандартноеОповещениеОЗакрытии;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекстСообщения = НСтр("ru = 'Пожалуйста, подождите...'");
	Если Не ПустаяСтрока(Параметры.ТекстСообщения) Тогда
		ТекстСообщения = Параметры.ТекстСообщения + Символы.ПС + ТекстСообщения;
		Элементы.ДекорацияПоясняющийТекстДлительнойОперации.Заголовок = ТекстСообщения;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.Заголовок) Тогда
		Элементы.СообщениеОперации.Заголовок = Параметры.Заголовок;
		Элементы.СообщениеОперации.ОтображатьЗаголовок = Истина;
	Иначе
		Элементы.СообщениеОперации.ОтображатьЗаголовок = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ИдентификаторЗадания) Тогда
		ИдентификаторЗадания = Параметры.ИдентификаторЗадания;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Верх;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МодульДлительныеОперацииКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ДлительныеОперацииКлиент");
	СтандартноеОповещениеОЗакрытии = ОписаниеОповещенияОЗакрытии <> Неопределено
	   И ОписаниеОповещенияОЗакрытии.Модуль = МодульДлительныеОперацииКлиент;
	
	Если Параметры.ВыводитьОкноОжидания Тогда
		ФормаЗакрывается = Ложь;
		Статус = "Выполняется";
		
		ДлительнаяОперация = Новый Структура;
		ДлительнаяОперация.Вставить("Статус", Статус);
		ДлительнаяОперация.Вставить("ИдентификаторЗадания", Параметры.ИдентификаторЗадания);
		ДлительнаяОперация.Вставить("Сообщения", Новый ФиксированныйМассив(Новый Массив));
		ДлительнаяОперация.Вставить("АдресРезультата", Параметры.АдресРезультата);
		ДлительнаяОперация.Вставить("АдресДополнительногоРезультата", Параметры.АдресДополнительногоРезультата);
		
		ОповещениеОЗавершении = Новый ОписаниеОповещения("ПриЗавершенииДлительнойОперации", ЭтотОбъект);
		ОповещениеОПрогрессе  = Новый ОписаниеОповещения("ПриПолученииПрогрессаДлительнойОперации", ЭтотОбъект);
		
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ВладелецФормы);
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
		ПараметрыОжидания.Интервал = Параметры.Интервал;
		ПараметрыОжидания.ОповещениеОПрогрессеВыполнения = ОповещениеОПрогрессе;
		
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Статус <> "Выполняется"
	 Или СтандартноеОповещениеОЗакрытии Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("Подключаемый_ОтменитьЗадание", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	ФормаЗакрывается = Истина;
	ОтключитьОбработчикОжидания("Подключаемый_ОтменитьЗадание");
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Статус <> "Выполняется" Тогда
		Возврат;
	КонецЕсли;
	
	Если СтандартноеОповещениеОЗакрытии Тогда
		ДлительнаяОперация = ПроверитьИОтменитьЕслиВыполняется(ИдентификаторЗадания);
		ЗавершитьДлительнуюОперациюИЗакрытьФорму(ДлительнаяОперация);
	Иначе
		ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриПолученииПрогрессаДлительнойОперации(ДлительнаяОперация, ДополнительныеПараметры) Экспорт
	
	Если ФормаЗакрывается Или Не Открыта() Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.ВыводитьПрогрессВыполнения
	   И ДлительнаяОперация.Прогресс <> Неопределено Тогда
		
		Процент = 0;
		Если ДлительнаяОперация.Прогресс.Свойство("Процент", Процент) Тогда
			Элементы.ДекорацияПроцент.Видимость = Истина;
			Элементы.ДекорацияПроцент.Заголовок = Строка(Процент) + "%";
		КонецЕсли;
		
		Текст = "";
		Если ДлительнаяОперация.Прогресс.Свойство("Текст", Текст) Тогда
			Элементы.ДекорацияПоясняющийТекстДлительнойОперации.Заголовок = СокрЛП(Текст);
		КонецЕсли;
		
	КонецЕсли;
	
	Если Параметры.ВыводитьСообщения
	   И ДлительнаяОперация.Сообщения <> Неопределено
	   И ВладелецФормы <> Неопределено Тогда
		
		ИдентификаторНазначения = ВладелецФормы.УникальныйИдентификатор;
		Для Каждого СообщениеПользователю Из ДлительнаяОперация.Сообщения Цикл
			СообщениеПользователю.ИдентификаторНазначения = ИдентификаторНазначения;
			СообщениеПользователю.Сообщить();
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗавершенииДлительнойОперации(ДлительнаяОперация, ДополнительныеПараметры) Экспорт
	
	Если ФормаЗакрывается Или Не Открыта() Тогда
		Возврат;
	КонецЕсли;
	
	ЗавершитьДлительнуюОперациюИЗакрытьФорму(ДлительнаяОперация);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьДлительнуюОперациюИЗакрытьФорму(ДлительнаяОперация)
	
	ДополнительныеПараметры = ?(СтандартноеОповещениеОЗакрытии,
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры, Неопределено);
	
	Если ДлительнаяОперация = Неопределено Тогда
		Статус = "Отменено";
	Иначе
		Статус = ДлительнаяОперация.Статус;
	КонецЕсли;
	
	Если Статус = "Отменено" Тогда
		Если СтандартноеОповещениеОЗакрытии Тогда
			ДополнительныеПараметры.Результат = Неопределено;
			Если Не ФормаЗакрывается Тогда
				Закрыть();
			КонецЕсли;
		Иначе
			Закрыть(Неопределено);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Если Параметры.ПолучатьРезультат Тогда
		Если Статус = "Выполнено" Тогда
			ДлительнаяОперация.Вставить("Результат", ПолучитьИзВременногоХранилища(Параметры.АдресРезультата));
		Иначе
			ДлительнаяОперация.Вставить("Результат", Неопределено);
		КонецЕсли;
	КонецЕсли;
	
	Если Статус = "Выполнено" Тогда
		
		ПоказатьОповещение();
		Если ВозвращатьРезультатВОбработкуВыбора() Тогда
			ОповеститьОВыборе(ДлительнаяОперация.Результат);
			Возврат;
		КонецЕсли;
		Результат = РезультатВыполнения(ДлительнаяОперация);
		Если СтандартноеОповещениеОЗакрытии Тогда
			ДополнительныеПараметры.Результат = Результат;
			Если Не ФормаЗакрывается Тогда
				Закрыть();
			КонецЕсли;
		Иначе
			Закрыть(Результат);
		КонецЕсли;
		
	ИначеЕсли Статус = "Ошибка" Тогда
		
		Результат = РезультатВыполнения(ДлительнаяОперация);
		Если СтандартноеОповещениеОЗакрытии Тогда
			ДополнительныеПараметры.Результат = Результат;
			Если Не ФормаЗакрывается Тогда
				Закрыть();
			КонецЕсли;
		Иначе
			Закрыть(Результат);
		КонецЕсли;
		Если ВозвращатьРезультатВОбработкуВыбора() Тогда
			ВызватьИсключение ДлительнаяОперация.КраткоеПредставлениеОшибки;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОтменитьЗадание()
	
	ФормаЗакрывается = Истина;
	
	ДлительнаяОперация = ПроверитьИОтменитьЕслиВыполняется(ИдентификаторЗадания);
	ЗавершитьДлительнуюОперациюИЗакрытьФорму(ДлительнаяОперация);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОповещение()
	
	Если Параметры.ОповещениеПользователя = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДлительныеОперацииКлиент.ПоказатьОповещение(Параметры.ОповещениеПользователя, ВладелецФормы);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьИОтменитьЕслиВыполняется(ИдентификаторЗадания)
	
	ДлительнаяОперация = ДлительныеОперации.ОперацияВыполнена(ИдентификаторЗадания);
	
	Если ДлительнаяОперация.Статус = "Выполняется" Тогда
		ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
		ДлительнаяОперация.Статус = "Отменено";
	КонецЕсли;
	
	Возврат ДлительнаяОперация;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ОтменитьВыполнениеЗадания(ИдентификаторЗадания)
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры

&НаКлиенте
Функция РезультатВыполнения(ДлительнаяОперация)
	
	Результат = Новый Структура;
	Результат.Вставить("Статус", ДлительнаяОперация.Статус);
	Результат.Вставить("АдресРезультата", Параметры.АдресРезультата);
	Результат.Вставить("АдресДополнительногоРезультата", Параметры.АдресДополнительногоРезультата);
	Результат.Вставить("КраткоеПредставлениеОшибки", ДлительнаяОперация.КраткоеПредставлениеОшибки);
	Результат.Вставить("ПодробноеПредставлениеОшибки", ДлительнаяОперация.ПодробноеПредставлениеОшибки);
	Результат.Вставить("Сообщения", Новый ФиксированныйМассив(Новый Массив));
	
	Если Параметры.ПолучатьРезультат Тогда
		Результат.Вставить("Результат", ДлительнаяОперация.Результат);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция ВозвращатьРезультатВОбработкуВыбора()
	
	ОповещениеОЗавершении = ?(СтандартноеОповещениеОЗакрытии,
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОповещениеОЗавершении,
		ОписаниеОповещенияОЗакрытии);
	
	Возврат ОповещениеОЗавершении = Неопределено
		И Параметры.ПолучатьРезультат
		И ТипЗнч(ВладелецФормы) = Тип("ФормаКлиентскогоПриложения");
	
КонецФункции

#КонецОбласти
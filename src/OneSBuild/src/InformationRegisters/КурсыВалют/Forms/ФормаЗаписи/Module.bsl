///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Запись.ИсходныйКлючЗаписи) Тогда
		Запись.Период = ТекущаяДатаСеанса();
	КонецЕсли;
	
	ЗаполнитьВалюту();

	ВыборВалютыДоступен = Не Параметры.ЗначенияЗаполнения.Свойство("Валюта") И Не ЗначениеЗаполнено(Параметры.Ключ);
	Элементы.ВалютаНадпись.Видимость = Не ВыборВалютыДоступен;
	Элементы.ВалютаСписок.Видимость = ВыборВалютыДоступен;
	
	КлючСохраненияПоложенияОкна = ?(ВыборВалютыДоступен, "СВыборомВалюты", "БезВыбораВалюты");
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДатыЗапретаИзменения") Тогда
		МодульДатыЗапретаИзменения = ОбщегоНазначения.ОбщийМодуль("ДатыЗапретаИзменения");
		МодульДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_КурсыВалют", ПараметрыЗаписи, Запись);
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Не ВыборВалютыДоступен Тогда
		ИсключаемыеРеквизиты = Новый Массив;
		ИсключаемыеРеквизиты.Добавить("ВалютаСписок");
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, ИсключаемыеРеквизиты);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВалютаПриИзменении(Элемент)
	Запись.Валюта = ВалютаСписок;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьВалюту()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Валюты.Ссылка КАК Ссылка,
	|	Валюты.Наименование КАК СимвольныйКод,
	|	Валюты.НаименованиеПолное КАК Наименование
	|ИЗ
	|	Справочник.Валюты КАК Валюты
	|ГДЕ
	|	Валюты.ПометкаУдаления = ЛОЖЬ
	|
	|УПОРЯДОЧИТЬ ПО
	|	Наименование";
	
	ВыборкаВалют = Запрос.Выполнить().Выбрать();
	
	Пока ВыборкаВалют.Следующий() Цикл
		ПредставлениеВалюты = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1 (%2)", ВыборкаВалют.Наименование, ВыборкаВалют.СимвольныйКод);
		Элементы.ВалютаСписок.СписокВыбора.Добавить(ВыборкаВалют.Ссылка, ПредставлениеВалюты);
		Если ВыборкаВалют.Ссылка = Запись.Валюта Тогда
			ВалютаНадпись = ПредставлениеВалюты;
			ВалютаСписок = Запись.Валюта;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

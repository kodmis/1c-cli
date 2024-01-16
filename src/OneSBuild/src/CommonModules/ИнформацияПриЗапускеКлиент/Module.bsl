///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Вызывается из обработчика ожидания, открывает окно информации.
Процедура Показать() Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ОценкаПроизводительности") Тогда
		МодульОценкаПроизводительностиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОценкаПроизводительностиКлиент");
		МодульОценкаПроизводительностиКлиент.ЗамерВремени("ВремяОткрытияИнформацииПриЗапуске");
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Реклама") Тогда
		МодульРаботаСРекламойКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСРекламойКлиент");
		МодульРаботаСРекламойКлиент.Показать();
	Иначе
		ОткрытьФорму("Обработка.ИнформацияПриЗапуске.Форма");
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ОбщегоНазначенияКлиентПереопределяемый.ПослеНачалаРаботыСистемы.
Процедура ПослеНачалаРаботыСистемы() Экспорт
	
	ПараметрыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	Если ПараметрыКлиента.Свойство("ИнформацияПриЗапуске") И ПараметрыКлиента.ИнформацияПриЗапуске.Показывать Тогда
		ПодключитьОбработчикОжидания("ПоказатьИнформациюПослеЗапуска", 0.2, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

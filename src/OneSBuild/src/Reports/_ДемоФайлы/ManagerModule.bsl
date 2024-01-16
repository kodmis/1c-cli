///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Параметры:
//   Настройки - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.Настройки.
//   НастройкиОтчета - см. ВариантыОтчетов.ОписаниеОтчета.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	НастройкиОтчета.Размещение.Удалить(Метаданные.Подсистемы._ДемоОрганайзер.Подсистемы._ДемоРаботаСФайлами);
	НастройкиОтчета.Размещение.Вставить(ВариантыОтчетовКлиентСервер.ИдентификаторНачальнойСтраницы(), "Важный");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Основной");
	НастройкиВарианта.Описание = НСтр("ru = 'Список файлов и их авторов в иерархии папок.'");
	НастройкиВарианта.НастройкиДляПоиска.КлючевыеСлова =
		НСтр("ru = 'Файловые функции
		|Динамика изменений файлов'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ПоРазмеру");
	НастройкиВарианта.Описание = НСтр("ru = 'Топ-10 самых больших файлов, отредактированных за указанный период.'");
	НастройкиВарианта.НастройкиДляПоиска.КлючевыеСлова =
		НСтр("ru = 'Топ-10
		|Крупные файлы'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ПоТипам");
	НастройкиВарианта.Описание = НСтр("ru = 'Круговая диаграмма использующихся типов файлов.'");
	НастройкиВарианта.НастройкиДляПоиска.КлючевыеСлова =
		НСтр("ru = 'Расширения'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ПоВерсиям");
	НастройкиВарианта.Описание = НСтр("ru = 'Список версий, файлов и папок в табличном виде.'");
	НастройкиВарианта.НастройкиДляПоиска.КлючевыеСлова =
		НСтр("ru = 'Версии
		|Загруженные файлы'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Вспомогательный");
	НастройкиВарианта.Включен = Ложь;
КонецПроцедуры

// Определяет список команд отчетов.
//
// Параметры:
//  КомандыОтчетов - см. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//  Параметры - см. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	Если ПравоДоступа("Просмотр", Метаданные.Отчеты._ДемоФайлы) Тогда
		Команда = КомандыОтчетов.Добавить();
		Команда.КлючВарианта      = "ПоВерсиям";
		Команда.ИмяПараметраФормы = "Отбор.Ссылка";
		Команда.Представление     = НСтр("ru = 'Демо: Отчет по версиям'");
		Команда.Идентификатор     = "_ДемоОтчетПоВерсиям";
		Команда.Важность          = "Важное";
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

// СтандартныеПодсистемы.ПодключаемыеКоманды

// Определяет настройки интеграции отчета с механизмами конфигурации. 
//
// Параметры:
//  НастройкиПрограммногоИнтерфейса - см. ПодключаемыеКоманды.НастройкиПодключаемогоОбъекта
//
Процедура ПриОпределенииНастроек(НастройкиПрограммногоИнтерфейса) Экспорт
	НастройкиПрограммногоИнтерфейса.НастроитьВариантыОтчета = Истина;
	НастройкиПрограммногоИнтерфейса.ОпределитьНастройкиФормы = Истина;
	НастройкиПрограммногоИнтерфейса.ДобавитьКомандыОтчетов = Истина;
	НастройкиПрограммногоИнтерфейса.Размещение.Добавить(Метаданные.Справочники.Файлы);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти

#КонецЕсли
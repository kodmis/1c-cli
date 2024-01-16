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
	
	ДеревоПредупреждений = РеквизитФормыВЗначение("Предупреждения");
	// Ошибочно включены в программный интерфейс.
	Если Параметры.ЛогСозданияОписания.ОшибочноПрограммный.Количество() > 0 Тогда
		Описание = НСтр("ru = 'Ошибочно включены в программный интерфейс'");
		Строка = ДеревоПредупреждений.Строки.Добавить();
		Строка.ВидПроблемы = Описание;
		ДополнитьДеревоПредупреждений(Параметры.ЛогСозданияОписания.ОшибочноПрограммный, Строка.Строки);
	КонецЕсли;
	
	// Длинный комментарий.
	Если Параметры.ЛогСозданияОписания.ДлинныйКомментарий.Количество() > 0 Тогда
		Описание = НСтр("ru = 'Длинный комментарий'");
		Строка = ДеревоПредупреждений.Строки.Добавить();
		Строка.ВидПроблемы = Описание;
		ДополнитьДеревоПредупреждений(Параметры.ЛогСозданияОписания.ДлинныйКомментарий, Строка.Строки);
	КонецЕсли;
	
	// Гиперссылка выводится в кавычках.
	Если Параметры.ЛогСозданияОписания.ГиперссылкаВКавычках.Количество() > 0 Тогда
		Описание = НСтр("ru = 'Гиперссылка выводится в кавычках'");
		Строка = ДеревоПредупреждений.Строки.Добавить();
		Строка.ВидПроблемы = Описание;
		ДополнитьДеревоПредупреждений(Параметры.ЛогСозданияОписания.ГиперссылкаВКавычках, Строка.Строки);
	КонецЕсли;
	
	// Не удалось добавить гиперссылку.
	Если Параметры.ЛогСозданияОписания.НеНайденаГиперссылка.Количество() > 0 Тогда
		Описание = НСтр("ru = 'Не удалось добавить гиперссылку'");
		Строка = ДеревоПредупреждений.Строки.Добавить();
		Строка.ВидПроблемы = Описание;
		ДополнитьДеревоПредупреждений(Параметры.ЛогСозданияОписания.НеНайденаГиперссылка, Строка.Строки, Истина);
	КонецЕсли;
	
	// Устаревшие методы вне области УстаревшиеПроцедурыИФункции.
	Если Параметры.ЛогСозданияОписания.УстаревшиеМетоды.Количество() > 0 Тогда
		Описание = НСтр("ru = 'Устаревшие методы вне области %1'");
		Описание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Описание, "УстаревшиеПроцедурыИФункции");
		Строка = ДеревоПредупреждений.Строки.Добавить();
		Строка.ВидПроблемы = Описание;
		ДополнитьДеревоПредупреждений(Параметры.ЛогСозданияОписания.УстаревшиеМетоды, Строка.Строки);
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(ДеревоПредупреждений, "Предупреждения");
	
КонецПроцедуры

&НаСервере
Процедура ДополнитьДеревоПредупреждений(Проблемы, ВетвьДерева, Список = Ложь)
	Номер = 1;
	Для Каждого Проблема Из Проблемы Цикл
		Строка = ВетвьДерева.Добавить();
		Если Список Тогда
			Строка.МестоОбнаружения = Проблема.Значение;
			Строка.Описание         = Проблема.Представление;
		Иначе
			Строка.МестоОбнаружения = Проблема;
		КонецЕсли;
		Строка.Номер = Номер;
		Номер = Номер + 1;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти


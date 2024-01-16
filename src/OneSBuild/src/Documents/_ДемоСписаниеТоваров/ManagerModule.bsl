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

// СтандартныеПодсистемы.Печать

// Заполняет список команд печати.
// 
// Параметры:
//  КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Акт о списании товаров
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "АктСписанияТоваров";
	КомандаПечати.Представление = НСтр("ru = 'Акт о списании товаров'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;

КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов - см. УправлениеПечатьюПереопределяемый.ПриПечати.МассивОбъектов
//  ПараметрыПечати - см. УправлениеПечатьюПереопределяемый.ПриПечати.ПараметрыПечати
//  КоллекцияПечатныхФорм - см. УправлениеПечатьюПереопределяемый.ПриПечати.КоллекцияПечатныхФорм
//  ОбъектыПечати - см. УправлениеПечатьюПереопределяемый.ПриПечати.ОбъектыПечати
//  ПараметрыВывода - см. УправлениеПечатьюПереопределяемый.ПриПечати.ПараметрыВывода
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "АктСписанияТоваров") Тогда

		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм, 
			"АктСписанияТоваров",
			НСтр("ru = 'Акт о списании товаров'"),
			СформироватьПечатнуюФормуАктСписанияТоваров(МассивОбъектов, ОбъектыПечати));
				
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
	"РазрешитьЧтение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(МестоХранения)
	|;
	|РазрешитьИзменениеЕслиРазрешеноЧтение
	|ГДЕ
	|	ЗначениеРазрешено(Ответственный)";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.ПодключаемыеКоманды

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
КонецПроцедуры

// Для использования в процедуре ДобавитьКомандыСозданияНаОсновании других модулей менеджеров объектов.
// Добавляет в список команд создания на основании этот объект.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
// Возвращаемое значение:
//  СтрокаТаблицыЗначений, Неопределено - описание добавленной команды.
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Возврат СозданиеНаОсновании.ДобавитьКомандуСозданияНаОсновании(КомандыСозданияНаОсновании, Метаданные.Документы._ДемоСписаниеТоваров);
	
КонецФункции

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СформироватьПечатнуюФормуАктСписанияТоваров(МассивОбъектов, ОбъектыПечати)

	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Документ.Ссылка КАК Ссылка,
	|	Документ.Номер КАК Номер,
	|	Документ.Дата КАК Дата,
	|	Документ.МестоХранения КАК Склад,
	|	Документ.Организация КАК Организация,
	|	ПРЕДСТАВЛЕНИЕ(Документ.МестоХранения) КАК СкладПредставление,
	|	Документ.Организация.Наименование КАК ОрганизацияПредставление,
	|	Документ.Организация.Префикс КАК Префикс,
	|	Документ.МестоХранения.МОЛ КАК Кладовщик,
	|	Документ.Ответственный КАК Ответственный
	|ИЗ
	|	Документ._ДемоСписаниеТоваров КАК Документ
	|ГДЕ
	|	Документ.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СписаниеТоваров.Ссылка КАК Ссылка,
	|	СписаниеТоваров.НомерСтроки КАК НомерСтроки,
	|	СписаниеТоваров.Номенклатура КАК Номенклатура,
	|	СписаниеТоваров.Количество КАК Количество,
	|	СписаниеТоваров.Номенклатура.Наименование КАК НоменклатураПредставление
	|ИЗ
	|	Документ._ДемоСписаниеТоваров.Товары КАК СписаниеТоваров
	|ГДЕ
	|	СписаниеТоваров.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	НомерСтроки
	|ИТОГИ ПО
	|	Ссылка";
	
	Результаты = Запрос.ВыполнитьПакет(); // Массив из РезультатЗапроса
	ВыборкаПоДокументам = Результаты.Получить(0).Выбрать();
	ВыборкаПоТоварам 	= Результаты.Получить(1).Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	РеквизитыДокумента 	= Новый Структура("Номер, Дата, Префикс");
	СинонимДокумента 	= НСтр("ru = 'Акт о списании товаров'");
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_СписаниеТоваров_АктОСписанииТоваров";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ._ДемоСписаниеТоваров.ПФ_MXL_АктОСписанииТоваров");
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	
	ОбластьНомераШапка = Макет.ПолучитьОбласть("ШапкаТаблицы|НомерСтроки");
	ОбластьТоварШапка  = Макет.ПолучитьОбласть("ШапкаТаблицы|Товар");
	ОбластьДанныеШапка = Макет.ПолучитьОбласть("ШапкаТаблицы|Данные");
	Макет.Область("Товар").ШиринаКолонки = Макет.Область("Товар").ШиринаКолонки
		+ Макет.Область("КолонкаКодов").ШиринаКолонки;
	ОбластьНомераСтрока = Макет.ПолучитьОбласть("Строка|НомерСтроки");
	ОбластьТоварСтрока  = Макет.ПолучитьОбласть("Строка|Товар");
	ОбластьДанныхСтрока = Макет.ПолучитьОбласть("Строка|Данные");
	
	ОбластьНомераПодвалТаблицы = Макет.ПолучитьОбласть("ПодвалТаблицы|НомерСтроки");
	ОбластьТоварПодвалТаблицы  = Макет.ПолучитьОбласть("ПодвалТаблицы|Товар");
	ОбластьДанныхПодвалТаблицы = Макет.ПолучитьОбласть("ПодвалТаблицы|Данные");
	
	ОбластьПодписи       	= Макет.ПолучитьОбласть("Подписи");
	ОбластьКоличествоВсего 	= Макет.ПолучитьОбласть("КоличествоВсего");
	
	ПервыйДокумент = Истина;
	Пока ВыборкаПоДокументам.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		ЗаполнитьЗначенияСвойств(РеквизитыДокумента, ВыборкаПоДокументам);
		
		ДопПараметрыЗаголовка = Новый Структура;
		ДопПараметрыЗаголовка.Вставить("ТекстЗаголовка", СформироватьЗаголовокДокумента(РеквизитыДокумента, СинонимДокумента));
		
		ОбластьЗаголовок.Параметры.Заполнить(ВыборкаПоДокументам);
		ОбластьЗаголовок.Параметры.Заполнить(ДопПараметрыЗаголовка);
		
		ТабДокумент.Вывести(ОбластьЗаголовок);
		
		// Вывод строк.
		Если НЕ ВыборкаПоТоварам.НайтиСледующий(Новый Структура("Ссылка",ВыборкаПоДокументам.Ссылка)) Тогда
			Продолжить;
		КонецЕсли;
		
		// Вывод шапки.
		ТабДокумент.Вывести(ОбластьНомераШапка);
		
		ТабДокумент.Присоединить(ОбластьТоварШапка);
		ТабДокумент.Присоединить(ОбластьДанныеШапка);
		
		ВсегоНаименований = 0;
		
		ВыборкаПоСтрокам = ВыборкаПоТоварам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаПоСтрокам.Следующий() Цикл
			ОбластьНомераСтрока.Параметры.Заполнить(ВыборкаПоСтрокам);
			ТабДокумент.Вывести(ОбластьНомераСтрока);
			
			// Номенклатура.
			ОбластьТоварСтрока.Параметры.Номенклатура = ВыборкаПоСтрокам.Номенклатура;
			ОбластьТоварСтрока.Параметры.НоменклатураПредставление = ВыборкаПоСтрокам.Номенклатура;
			ТабДокумент.Присоединить(ОбластьТоварСтрока);
			// Данные количестве.
			ОбластьДанныхСтрока.Параметры.Заполнить(ВыборкаПоСтрокам);
			ТабДокумент.Присоединить(ОбластьДанныхСтрока);
			ВсегоНаименований = ВсегоНаименований + 1;
		КонецЦикла;
		
		// Вывод итогов.
		ТабДокумент.Вывести(ОбластьНомераПодвалТаблицы);
		ТабДокумент.Присоединить(ОбластьТоварПодвалТаблицы);
		ТабДокумент.Присоединить(ОбластьДанныхПодвалТаблицы);
		ТекстИтоговойСтроки = НСтр("ru = 'Всего наименований %ВсегоНаименований%'");
		ТекстИтоговойСтроки = СтрЗаменить(ТекстИтоговойСтроки,"%ВсегоНаименований%", ВсегоНаименований);
		ОбластьКоличествоВсего.Параметры.ИтоговаяСтрока = ТекстИтоговойСтроки;
		ТабДокумент.Вывести(ОбластьКоличествоВсего);
		
		// Вывод подписей.
		ОбластьПодписи.Параметры.Ответственный = ВыборкаПоДокументам.Ответственный;
		ОбластьПодписи.Параметры.Кладовщик = ВыборкаПоДокументам.Кладовщик;
		ТабДокумент.Вывести(ОбластьПодписи);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаПоДокументам.Ссылка);
		
	КонецЦикла;
	
	Если ПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	Возврат ТабДокумент;
	
КонецФункции

// Возвращает заголовок документа в том виде, в котором его формирует платформа для представления ссылки на документ.
//
// Параметры:
//  Шапка - Структура:
//          Номер - Строка, Число - номер документа.
//          Дата  - Дата - дата документа.
//  НазваниеДокумента - Строка - название документа (например, синоним объекта метаданных).
//
// Возвращаемое значение 
//  Строка - заголовок документа.
//
Функция СформироватьЗаголовокДокумента(Шапка, Знач НазваниеДокумента = "", УдалитьТолькоЛидирующиеНулиИзНомераОбъекта = Ложь)
	
	ДанныеДокумента = Новый Структура("Номер,Дата,Представление");
	ЗаполнитьЗначенияСвойств(ДанныеДокумента, Шапка);
	
	// Если название документа не передано, получим название по представлению документа.
	Если ПустаяСтрока(НазваниеДокумента) И ЗначениеЗаполнено(ДанныеДокумента.Представление) Тогда
		ПоложениеНомера = СтрНайти(ДанныеДокумента.Представление, ДанныеДокумента.Номер);
		Если ПоложениеНомера > 0 Тогда
			НазваниеДокумента = СокрЛП(Лев(ДанныеДокумента.Представление, ПоложениеНомера - 1));
		КонецЕсли;
	КонецЕсли;

	Если УдалитьТолькоЛидирующиеНулиИзНомераОбъекта Тогда
		НомерНаПечать = ПрефиксацияОбъектовКлиентСервер.УдалитьЛидирующиеНулиИзНомераОбъекта(ДанныеДокумента.Номер);
	Иначе 
		// Кроме лидирующих нулей будут удалены также префикс организации и префикс информационной базы.
		НомерНаПечать = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеДокумента.Номер);
	КонецЕсли;
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 № %2 от %3'"),
		НазваниеДокумента, НомерНаПечать, Формат(ДанныеДокумента.Дата, "ДЛФ=DD"));
	
КонецФункции

#КонецОбласти

#КонецЕсли

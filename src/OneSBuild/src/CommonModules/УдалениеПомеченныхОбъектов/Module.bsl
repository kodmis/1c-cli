///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Безвозвратно удаляет объекты, помеченные на удаление, выполняя при этом контроль ссылочной целостности.
//
// Параметры:
//  УдаляемыеОбъекты - Массив из ПланОбменаСсылка - объекты для удаления.
//                   - Массив из СправочникСсылка
//                   - Массив из ДокументСсылка
//                   - Массив из ПланСчетовСсылка
//                   - Массив из ПланВидовРасчетаСсылка
//                   - Массив из БизнесПроцессСсылка
//                   - Массив из ЗадачаСсылка
//  РежимУдаления - Строка - способ удаления, может принимать значения:
//		"Стандартный" - удаление объектов с контролем ссылочной целостности и сохранением возможности 
//					  многопользовательской работы.
//		"Монопольный" - удаление объектов с контролем ссылочной целостности с установкой монопольного режима.
//					    Если монопольный режим установить не удалось, то будет вызвано исключение.
//		"Упрощенный"  - удаление объектов, при котором контроль ссылочной целостности выполняется только в непомеченных
//					  на удаление объектах. В помеченных на удаление объектах ссылки на удаляемые объекты 
//					  будут очищены.
//
// Возвращаемое значение:	
//    Структура:
//      * Успешно - Булево - Истина, если все объекты были удалены.
//      * ПрепятствующиеУдалению - ТаблицаЗначений - объекты, в которых есть ссылки на удаляемые объекты:
//        ** УдаляемыйСсылка - ЛюбаяСсылка
//        ** МестоИспользования - ЛюбаяСсылка - ссылка на объект, препятствующий удалению.
//									  - Неопределено - объект используется в константе или 
//									  	в процессе удаление произошла ошибка. Информация о константе указана в поле метаданные.
//									  	Информация об ошибке указана в поле ОписаниеОшибки.
//        ** ОписаниеОшибки - Строка - описание ошибки при удалении объекта.
//        ** ПодробноеОписаниеОшибки - Строка - подробное описание ошибки при удалении объекта.
//        ** Метаданные - ОбъектМетаданных - описание метаданных объекта, препятствующего удалению.
//        * Удаленные - Массив из ЛюбаяСсылка- успешно удаленные объекты.
//        * НеУдаленные - Массив из ЛюбаяСсылка - не удаленные объекты.
//
Функция УдалитьПомеченныеОбъекты(УдаляемыеОбъекты, РежимУдаления = "Стандартный") Экспорт
	Возврат УдалениеПомеченныхОбъектовСлужебный.УдалитьПомеченныеОбъектыСлужебный(УдаляемыеОбъекты, РежимУдаления);
КонецФункции

// Формирует помеченные на удаление с учетом разделения и фильтрацией служебных и предопределенных объектов.
// При выполнении в разделенном сеансе будут возвращены объекты с учетом разделителя.
// Предопределенные элементы исключаются из результата поиска.
// 
// Параметры:
//   ОтборМетаданных - СписокЗначений из Строка - список из полных имен метаданных, в которых будет
// 												 выполнен поиск помеченных на удаление.
// 												 Например, "Справочник._ДемоНоменклатура".
//                   - Неопределено - отбор по объектам метаданных накладываться не будет.
//
//  ИскатьТехнологическиеОбъекты - Булево - если Истина, то поиск будет осуществляться в объектах метаданных,
//											добавленных в исключения поиска ссылок. 
//											см. ОбщегоНазначения.ИсключенияПоискаСсылок. 
//											Например, в справочнике КлючиДоступа.
//
//
// Возвращаемое значение:
//   Массив из ЛюбаяСсылка
//
Функция ПомеченныеНаУдаление(Знач ОтборМетаданных = Неопределено, ИскатьТехнологическиеОбъекты = Ложь) Экспорт
	ИсключенияПоискаУдаляемых = Новый Массив;
	Результат = Новый Массив;
	
	ЭтоМодельСервиса = ОбщегоНазначения.РазделениеВключено();
	ВОбластиДанных = ?(ЭтоМодельСервиса, ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных(), Ложь);
	ОтборМетаданных = ?(ОтборМетаданных <> Неопределено И ОтборМетаданных.Количество() > 0,
		ОтборМетаданных.ВыгрузитьЗначения(), Неопределено);
	
	Если НЕ ИскатьТехнологическиеОбъекты Тогда
		ИсключенияПоискаСсылок = ОбщегоНазначения.ИсключенияПоискаСсылок();
		Для Каждого ИсключенияПоиска Из ИсключенияПоискаСсылок Цикл
			Если ИсключенияПоиска.Значение = "*" Тогда
				ИсключенияПоискаУдаляемых.Добавить(ИсключенияПоиска.Ключ);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	КешИнформацииОТипе = Новый Соответствие;
	Для Каждого Элемент Из НайтиПомеченныеНаУдаление( , ОтборМетаданных, ИсключенияПоискаУдаляемых) Цикл
		Если СоответствуетОтборуМетаданных(ОтборМетаданных, Элемент)
			И ИсключенияПоискаУдаляемых.Найти(Элемент.Метаданные()) = Неопределено Тогда

			Информация = УдалениеПомеченныхОбъектовСлужебный.ИнформацияОТипе(
				ТипЗнч(Элемент), КешИнформацииОТипе);
			ЭтоПредопределенный = Информация.ЕстьПредопределенные 
				И Информация.Предопределенные.Найти(Элемент) <> Неопределено;
			ЭтоНеразделенныйОбъектВОбластиДанных = ВОбластиДанных И Не Информация.Разделенный;

			ОбъектПодлежитУдалению = НЕ ЭтоПредопределенный 
				И НЕ ЭтоНеразделенныйОбъектВОбластиДанных
				И (НЕ Информация.Технический
					ИЛИ ИскатьТехнологическиеОбъекты);
			
			Если ОбъектПодлежитУдалению Тогда
				Результат.Добавить(Элемент);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	Возврат Результат;
КонецФункции

#Область ПрограммныйИнтерфейсФорм

// Устанавливает видимость помеченных на удаление.
// 
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма с динамическим списком
//   НастройкиОтображенияПомеченныхОбъектов - см. НастройкиОтображенияПомеченныхОбъектов
//                                          - ТаблицаФормы - элемент формы динамического списка. 
//
// Пример:
// 	// Для настройки одного списка
// 	УдалениеПомеченныхОбъектов.ПриСозданииНаСервере(ЭтотОбъект, Элементы.Список);
// 	
// 	// Для настройки нескольких списков
// 	НастройкиОтображенияПомеченных = УдалениеПомеченныхОбъектов.НастройкиОтображенияПомеченныхОбъектов();
// 	Настройка = НастройкиОтображения.Добавить();
// 	Настройка.ИмяЭлементаФормы = Элементы.Список1.Имя;
// 	Настройка = НастройкиОтображения.Добавить();
// 	Настройка.ИмяЭлементаФормы = Элементы.Список2.Имя;
// 	 
// 	// Установка основной таблицы необходима для перехода к спискам помеченных объектов 
// 	// с предустановленным отбором
// 	ОсновныеТаблицыСписка = Новый СписокЗначений();
// 	ОсновныеТаблицыСписка.Добавить("Справочник._ДемоНоменклатура");
// 	Настройка.ТипыМетаданных = ОсновныеТаблицыСписка;
// 	УдалениеПомеченныхОбъектов.ПриСозданииНаСервере(ЭтотОбъект, НастройкиОтображенияПомеченных);
//
Процедура ПриСозданииНаСервере(Форма, Знач НастройкиОтображенияПомеченныхОбъектов) Экспорт
	Если ТипЗнч(НастройкиОтображенияПомеченныхОбъектов) <> Тип("ТаблицаЗначений") Тогда
		НастройкиОтображенияПомеченныхОбъектов = НастройкаОтображенияПомеченныхОбъектовСписка(Форма,
			НастройкиОтображенияПомеченныхОбъектов);
	Иначе
		ЗаполнитьИменаСпискаПоЭлементамФормы(Форма, НастройкиОтображенияПомеченныхОбъектов);
	КонецЕсли;

	СоздатьРеквизитХраненияНастроек(Форма);
	Для Каждого Настройка Из НастройкиОтображенияПомеченныхОбъектов Цикл
		ЗначениеОтбора = УдалениеПомеченныхОбъектовСлужебный.ЗагрузитьНастройкуОтображенияПомеченныхНаУдаления(
			Форма.ИмяФормы, Настройка.ИмяСписка);
		УстановитьНастройкиСписка(Форма, Настройка, ЗначениеОтбора);
	КонецЦикла;

КонецПроцедуры

// Формирует настройки отображения помеченных на удаления объектов.
// 
// Возвращаемое значение:
//   ТаблицаЗначений:
//   * ИмяЭлементаФормы - Строка - имя таблицы формы, связанного с динамическим списком.
//   * ТипыМетаданных - СписокЗначений из Строка - типы объектов, отображаемых в динамическом списке.
//   * ИмяСписка - Строка - необязательный. Имя динамического списка на форме.
//
Функция НастройкиОтображенияПомеченныхОбъектов() Экспорт

	Настройки = Новый ТаблицаЗначений;
	Настройки.Колонки.Добавить("ИмяСписка", Новый ОписаниеТипов("Строка"));
	Настройки.Колонки.Добавить("ТипыМетаданных", Новый ОписаниеТипов("СписокЗначений"));
	Настройки.Колонки.Добавить("ИмяЭлементаФормы", Новый ОписаниеТипов("Строка"));
	Возврат Настройки;

КонецФункции

// Возвращает информацию о настройках удаления помеченных по расписанию.
// Пример использования см. в документации.
// 
// Возвращаемое значение:
//   Структура:
//   * Расписание - см. РегламентныеЗаданияСервер.РасписаниеРегламентногоЗадания
//   * Использование - Булево - признак использования регламентного задания.
//
Функция РежимУдалятьПоРасписанию() Экспорт
	Возврат УдалениеПомеченныхОбъектовСлужебныйВызовСервера.РежимУдалятьПоРасписанию();
КонецФункции

// Устанавливает пометку команды Показать помеченные в соответствии с сохраненными настройками пользователя.
// Используется для установки начального значения пометки кнопки формы.
// 
// Параметры:
//   Форма - ФормаКлиентскогоПриложения 	
//   ТаблицаФормы - ТаблицаФормы - таблица формы, связанная с динамическим списком
//   КнопкаФормы - КнопкаФормы - кнопка, связанная с командой Показать помеченные
//
Процедура УстановитьПометкуКомандыПоказатьПомеченные(Форма, ТаблицаФормы, КнопкаФормы) Экспорт
	ЗначениеОтбора = УдалениеПомеченныхОбъектовСлужебный.ЗагрузитьНастройкуОтображенияПомеченныхНаУдаления(
		Форма.ИмяФормы, ТаблицаФормы.Имя);
	Форма.Элементы.ПоказатьПомеченныеНаУдаление.Пометка = Не ЗначениеОтбора;
КонецПроцедуры

#КонецОбласти

// Возвращает перечень объектов, которые удаляются в текущий момент и на которые есть ссылки в объекте.
// 
// Параметры:
//   Источник - СправочникОбъект
//            - ДокументОбъект - объект, в котором будет выполнен поиск удаляемых объектов
//
// Возвращаемое значение:
//   Соответствие из КлючИЗначение:
//   * Ключ -ЛюбаяСсылка - перечень удаляемых объектов, которые есть в источнике.
//   * Значение - Строка - представление ссылки
//
Функция СсылкиНаУдаляемыеОбъекты(Источник) Экспорт
	СсылкиНаУдаляемыеОбъекты = Новый Соответствие;
	МетаданныеИсточника = Источник.Метаданные();
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Источник, "Ссылка") Тогда
		ОписанияСсылок = СсылкаНаУдаляемыеОбъектыВОбъекте(
			ОписаниеОбъекта(Источник, МетаданныеИсточника),
			МетаданныеИсточника);
	ИначеЕсли ОбщегоНазначения.ЭтоКонстанта(МетаданныеИсточника) Тогда
		ЗначениеКонстанты = Источник.Значение;
		Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(ЗначениеКонстанты)) Тогда 
			ОписанияСсылок = НовыйСсылкиВОбъекте();
			ОписаниеСсылки = ОписанияСсылок.Добавить();
			ОписаниеСсылки.Ссылка = ЗначениеКонстанты;
			ОписаниеСсылки.Таблица = МетаданныеИсточника.ПолноеИмя();
			ОписаниеСсылки.Поле = "Значение";
		КонецЕсли;
	ИначеЕсли ЭтоНезависимыйРегистрСведений(МетаданныеИсточника) Тогда
		ОписанияСсылок = СсылкиНаУдаляемыеОбъектыВНаборе(
			ОписаниеНабора(Источник, МетаданныеИсточника),
			МетаданныеИсточника);
	Иначе
		Возврат Новый Соответствие;
	КонецЕсли; 
	
	УдаляемыеСсылки = УдаляемыеСсылкиВКоллекции(
		ОписанияСсылок.ВыгрузитьКолонку("Ссылка"));
	УдаляемыеСсылкиПометкиУдаления = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(
		УдаляемыеСсылки,
		"ПометкаУдаления");
		
    ДобавленныеСсылки = СсылкиДобавленныеПриИзмененииОбъекта(
		ОписанияСсылок, 
		УдаляемыеСсылкиПометкиУдаления);

	Для каждого ОписаниеСсылки Из ДобавленныеСсылки Цикл
		СсылкиНаУдаляемыеОбъекты.Вставить(ОписаниеСсылки.Ссылка, ОписаниеСсылки.Представление);
	КонецЦикла;
	
	Возврат СсылкиНаУдаляемыеОбъекты;
КонецФункции

#Область УстаревшиеПроцедурыИФункции

// Устарела. Состояние флажка для формы настроек удаления помеченных объектов.
// Следует использовать УдалениеПомеченныхОбъектов.РежимУдалятьПоРасписанию.
//
// Возвращаемое значение: 
//   Булево - значение.
//
Функция ЗначениеФлажкаУдалятьПоРасписанию() Экспорт

	Отбор = Новый Структура;
	Отбор.Вставить("Метаданные", Метаданные.РегламентныеЗадания.УдалениеПомеченныхОбъектов);
	Задания = РегламентныеЗаданияСервер.НайтиЗадания(Отбор);

	Для Каждого Задание Из Задания Цикл
		Возврат Задание.Использование;
	КонецЦикла;

	Возврат Ложь;

КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует настройки скрытия помеченных объектов для динамического списка.
// 
// Параметры:
//   Форма - ФормаКлиентскогоПриложения
//   ЭлементСписок - ТаблицаФормы
//   ТипыМетаданных - Массив из Строка
//                  - Неопределено - по умолчанию основная таблица динамического списка 
//
// Возвращаемое значение:
//   см. НастройкиОтображенияПомеченныхОбъектов
//
Функция НастройкаОтображенияПомеченныхОбъектовСписка(Форма, ЭлементСписок, ТипыМетаданных = Неопределено)
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр("НастройкаОтображенияПомеченныхОбъектовСписка", "ЭлементСписок",
		ЭлементСписок, Новый ОписаниеТипов("ТаблицаФормы"));
	Список = Форма[ЭлементСписок.ПутьКДанным]; // ДинамическийСписок

	Настройки = НастройкиОтображенияПомеченныхОбъектов();
	Настройка = Настройки.Добавить();
	Настройка.ИмяСписка = ЭлементСписок.ПутьКДанным;
	Настройка.ИмяЭлементаФормы = ЭлементСписок.Имя;
	Если ТипыМетаданных = Неопределено И ЗначениеЗаполнено(Список.ОсновнаяТаблица) Тогда

		СписокТипов = Новый СписокЗначений;
		СписокТипов.Добавить(Список.ОсновнаяТаблица);
		Настройка.ТипыМетаданных = СписокТипов;
	Иначе
		Настройка.ТипыМетаданных = ТипыМетаданных;
	КонецЕсли;

	Возврат Настройки;
КонецФункции

// Выводит на форму элементы управления и устраняет конфликты фиксированных и пользовательских настроек списка.
// 
// Параметры:
//   Форма - ФормаКлиентскогоПриложения
//   Настройка - см. НастройкиОтображенияПомеченныхОбъектов
//
Процедура УстановитьНастройкиСписка(Форма, Настройка, ЗначениеОтбора)

	УдалитьПользовательскуюНастройкуОтбораПомеченныхНаУдаление(Форма, Настройка.ИмяСписка);
	УдалениеПомеченныхОбъектовСлужебныйКлиентСервер.УстановитьОтборПоПометкеУдаления(Форма[Настройка.ИмяСписка],
		ЗначениеОтбора);
	СохранитьНастройкуВДанныхФормы(Форма, Настройка, ЗначениеОтбора);

КонецПроцедуры

Процедура СохранитьНастройкуВДанныхФормы(Форма, Настройка, ЗначениеОтбора)
	ОписаниеНастройки = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(Настройка);
	ОписаниеНастройки.Вставить("ЗначениеОтбора", ЗначениеОтбора);
	ОписаниеНастройки.Вставить("ЗначениеПометки", Не ЗначениеОтбора);
	Форма.ПараметрыУдаленияПомеченных.Вставить(Настройка.ИмяЭлементаФормы, ОписаниеНастройки);
КонецПроцедуры

// Параметры:
//   Форма - ФормаКлиентскогоПриложения
//     * ПараметрыУдаленияПомеченных - Структура 
//
Процедура СоздатьРеквизитХраненияНастроек(Форма)
	
	ИмяРеквизита = "ПараметрыУдаленияПомеченных";
	ЗначенияСвойств = Новый Структура(ИмяРеквизита, Null);
	ЗаполнитьЗначенияСвойств(ЗначенияСвойств, Форма);
	ПараметрыУдаленияПомеченных = ЗначенияСвойств.ПараметрыУдаленияПомеченных;
	Если ТипЗнч(ПараметрыУдаленияПомеченных) <> Тип("Структура") Тогда
		ДобавляемыеРеквизиты = Новый Массив;
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы(ИмяРеквизита, Новый ОписаниеТипов));
		Форма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
		Форма.ПараметрыУдаленияПомеченных = Новый Структура;
	КонецЕсли;
		
КонецПроцедуры

// Удаляет отбор по полю ПометкаУдаления из сохраненных пользовательских настроек
// 
// Параметры:
//   Форма - ФормаКлиентскогоПриложения 
//   ИмяСписка - Строка 
//
Процедура УдалитьПользовательскуюНастройкуОтбораПомеченныхНаУдаление(Форма, ИмяСписка)

	КлючНастроек = Форма.ИмяФормы + "." + ИмяСписка + "/ТекущиеПользовательскиеНастройки";
	Настройки = ОбщегоНазначения.ХранилищеСистемныхНастроекЗагрузить(КлючНастроек, ""); // ПользовательскиеНастройкиКомпоновкиДанных -
	ДинамическийСписок = Форма[ИмяСписка]; // ДинамическийСписок - 
	ПолеПометкиУдаления = ДинамическийСписок.КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора.Элементы.Найти(
		"ПометкаУдаления");

	Если Настройки <> Неопределено И ПолеПометкиУдаления <> Неопределено Тогда
		УдалитьЭлементОтбораПользовательскихНастроек(Настройки, ПолеПометкиУдаления);
		ОбщегоНазначения.ХранилищеСистемныхНастроекСохранить(КлючНастроек, "", Настройки);
	КонецЕсли;

КонецПроцедуры

Процедура УдалитьЭлементОтбораПользовательскихНастроек(Знач Настройки, Знач ПолеПометкиУдаления)

	Для Каждого Настройка Из Настройки.Элементы Цикл

		Если ТипЗнч(Настройка) <> Тип("ОтборКомпоновкиДанных") Тогда
			Продолжить;
		КонецЕсли;

		Для Сч = -(Настройка.Элементы.Количество() - 1) По 0 Цикл
			ЭлементНастройки = Настройка.Элементы[-Сч]; // ОтборКомпоновкиДанных
			Если ЭлементНастройки.ЛевоеЗначение = ПолеПометкиУдаления.Поле Тогда
				Настройка.Элементы.Удалить(ЭлементНастройки);
			КонецЕсли;
		КонецЦикла;

	КонецЦикла;

КонецПроцедуры

//	Параметры:
//    НастройкиОтображенияПомеченныхОбъектов - см. НастройкаОтображенияПомеченныхОбъектовСписка
//
Процедура ЗаполнитьИменаСпискаПоЭлементамФормы(Форма, НастройкиОтображенияПомеченныхОбъектов)
	Для Каждого Настройка Из НастройкиОтображенияПомеченныхОбъектов Цикл
		ТаблицаФормы = Форма.Элементы[Настройка.ИмяЭлементаФормы];// ТаблицаФормы - 
		Настройка.ИмяСписка = ТаблицаФормы.ПутьКДанным;
	КонецЦикла;
КонецПроцедуры

Функция СсылкиНаУдаляемыеОбъектыВРеквизитах(ОписаниеИсточника, Реквизиты)
	ЗначенияСсылочныхТипов = НовыйСсылкиВОбъекте();

	Для Каждого Реквизит Из Реквизиты Цикл

		Если Реквизит.Имя = "Ссылка" Тогда
			Продолжить;
		КонецЕсли;

		Значение = ОписаниеИсточника.Источник[Реквизит.Имя];
		ТипЗначения = ТипЗнч(Значение);
		Если ЗначениеЗаполнено(Значение) И ОбщегоНазначения.ЭтоСсылка(ТипЗначения) Тогда
			ОписаниеСсылки = ЗначенияСсылочныхТипов.Добавить();
			ОписаниеСсылки.Ссылка = Значение;
			ОписаниеСсылки.Таблица = ОписаниеИсточника.Таблица;
			ОписаниеСсылки.Поле = Реквизит.Имя;
			ОписаниеСсылки.УсловиеОтбора = ОписаниеИсточника.УсловиеОтбора;
		КонецЕсли;
	КонецЦикла;

	Возврат ЗначенияСсылочныхТипов;
КонецФункции

Функция СсылкиНаУдаляемыеОбъектовВТабличныхЧастях(ОписаниеИсточника, ТабличныеЧасти, ИмяКоллекцииРеквизитов = "Реквизиты")
	ЗначенияСсылочныхТипов = НовыйСсылкиВОбъекте();

	Для Каждого ТабличнаяЧасть Из ТабличныеЧасти Цикл
		
		Если НЕ ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ОписаниеИсточника.Источник, ТабличнаяЧасть.Имя) Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого СтрокаТЧ Из ОписаниеИсточника.Источник[ТабличнаяЧасть.Имя] Цикл
			ОписаниеТабличнойЧасти = ОбщегоНазначения.СкопироватьРекурсивно(ОписаниеИсточника);
			ОписаниеТабличнойЧасти.Источник = СтрокаТЧ;
			ОписаниеТабличнойЧасти.Таблица = ОписаниеИсточника.Таблица + "." + ТабличнаяЧасть.Имя;
			
			ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(
				СсылкиНаУдаляемыеОбъектыВРеквизитах(ОписаниеТабличнойЧасти, ТабличнаяЧасть[ИмяКоллекцииРеквизитов]),
				ЗначенияСсылочныхТипов);
		КонецЦикла;
	КонецЦикла;

	Возврат ЗначенияСсылочныхТипов;
КонецФункции

Функция СсылкиНаУдаляемыеОбъектыВНабореЗаписей(ОписаниеИсточника, Знач Реквизиты, ЭтоРегистрБухгалтерии = Ложь)
	ЗначенияСсылочныхТипов = НовыйСсылкиВОбъекте();

	Для Каждого Запись Из ОписаниеИсточника.Источник Цикл
		ОписаниеЗаписи = ОбщегоНазначения.СкопироватьРекурсивно(ОписаниеИсточника);
		ОписаниеЗаписи.Источник = Запись;
		
		Для каждого УсловиеОтбора Из ОписаниеИсточника.УсловиеОтбора Цикл
			ОписаниеЗаписи.УсловиеОтбора.Вставить(УсловиеОтбора.Ключ, Запись[УсловиеОтбора.Ключ]);	
		КонецЦикла;
		
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(
			СсылкиНаУдаляемыеОбъектыВРеквизитах(ОписаниеЗаписи, Реквизиты),
			ЗначенияСсылочныхТипов);
	КонецЦикла;

	Возврат ЗначенияСсылочныхТипов;
КонецФункции

// Параметры:
//   Реквизиты -  КоллекцияОбъектовМетаданных
//
// Возвращаемое значение:
//   Массив
//
Функция СформироватьРеквизитыРегистровБухгалтерииСКорреспонденцией(Знач Реквизиты)
	РеквизитыРегистраСКорреспонденцией = Новый Массив;
	
	Для Каждого Реквизит Из Реквизиты Цикл
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Реквизит, "Балансовый")
			 И (Реквизит.Балансовый) Тогда
			РеквизитыРегистраСКорреспонденцией.Добавить(Новый Структура("Имя", Реквизит.Имя));
		Иначе
			РеквизитыРегистраСКорреспонденцией.Добавить(Новый Структура("Имя", Реквизит.Имя + "Дт"));			
			РеквизитыРегистраСКорреспонденцией.Добавить(Новый Структура("Имя", Реквизит.Имя + "Кт"));			
		КонецЕсли;
	КонецЦикла;
	
	Возврат РеквизитыРегистраСКорреспонденцией;
КонецФункции

#Область СсылкиНаУдаляемыеОбъекты

Функция СсылкаНаУдаляемыеОбъектыВОбъекте(Источник, МетаданныеИсточника)
	ЗначенияСсылочныхТипов = НовыйСсылкиВОбъекте();
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(МетаданныеИсточника, "СтандартныеРеквизиты") Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(
			СсылкиНаУдаляемыеОбъектыВРеквизитах(Источник, МетаданныеИсточника.СтандартныеРеквизиты),
			ЗначенияСсылочныхТипов);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(МетаданныеИсточника, "РеквизитыАдресации") Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(
			СсылкиНаУдаляемыеОбъектыВРеквизитах(Источник, МетаданныеИсточника.РеквизитыАдресации),
			ЗначенияСсылочныхТипов);
	КонецЕсли;

	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(МетаданныеИсточника, "Реквизиты") Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(
			СсылкиНаУдаляемыеОбъектыВРеквизитах(Источник, МетаданныеИсточника.Реквизиты),
			ЗначенияСсылочныхТипов);
	КонецЕсли;

	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(МетаданныеИсточника, "ТабличныеЧасти") Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(
			СсылкиНаУдаляемыеОбъектовВТабличныхЧастях(Источник, МетаданныеИсточника.ТабличныеЧасти),
			ЗначенияСсылочныхТипов);
	КонецЕсли;

	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(МетаданныеИсточника,"СтандартныеТабличныеЧасти") Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(
			СсылкиНаУдаляемыеОбъектовВТабличныхЧастях(Источник, МетаданныеИсточника.СтандартныеТабличныеЧасти, "СтандартныеРеквизиты"),
			ЗначенияСсылочныхТипов);
	КонецЕсли;
	
	Возврат ЗначенияСсылочныхТипов;
КонецФункции

Функция СсылкиНаУдаляемыеОбъектыВНаборе(Источник, МетаданныеИсточника)
	ЗначенияСсылочныхТипов = НовыйСсылкиВОбъекте();
	ЭтоРегистрБухгалтерии = ОбщегоНазначения.ЭтоРегистрБухгалтерии(МетаданныеИсточника);
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(МетаданныеИсточника, "Измерения") Тогда
		Если ОбщегоНазначения.ЭтоРегистрБухгалтерии(МетаданныеИсточника) И МетаданныеИсточника.Корреспонденция Тогда
			Реквизиты = СформироватьРеквизитыРегистровБухгалтерииСКорреспонденцией( МетаданныеИсточника.Измерения);
		Иначе	
			Реквизиты =  МетаданныеИсточника.Измерения;
		КонецЕсли;
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(
			СсылкиНаУдаляемыеОбъектыВНабореЗаписей(Источник, Реквизиты, ЭтоРегистрБухгалтерии),
			ЗначенияСсылочныхТипов);
	КонецЕсли;

	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(МетаданныеИсточника, "Ресурсы") Тогда
		Если ОбщегоНазначения.ЭтоРегистрБухгалтерии(МетаданныеИсточника) И МетаданныеИсточника.Корреспонденция Тогда
			Реквизиты = СформироватьРеквизитыРегистровБухгалтерииСКорреспонденцией( МетаданныеИсточника.Ресурсы);
		Иначе	
			Реквизиты =  МетаданныеИсточника.Ресурсы;
		КонецЕсли;
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(
			СсылкиНаУдаляемыеОбъектыВНабореЗаписей(Источник, Реквизиты, ЭтоРегистрБухгалтерии),
			ЗначенияСсылочныхТипов);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(МетаданныеИсточника,"СтандартныеРеквизиты") Тогда
		Если ЭтоРегистрБухгалтерии Тогда
			Реквизиты = СформироватьСтандартныеРеквизитыРегистраБухгалтерии(МетаданныеИсточника);
		Иначе
			Реквизиты = МетаданныеИсточника.СтандартныеРеквизиты;
		КонецЕсли;	
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(
			СсылкиНаУдаляемыеОбъектыВНабореЗаписей(Источник, Реквизиты, ЭтоРегистрБухгалтерии),
			ЗначенияСсылочныхТипов);
	КонецЕсли;

	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(МетаданныеИсточника, "Реквизиты") Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(
			СсылкиНаУдаляемыеОбъектыВНабореЗаписей(Источник, МетаданныеИсточника.Реквизиты, ЭтоРегистрБухгалтерии),
			ЗначенияСсылочныхТипов);
	КонецЕсли;
	
	Возврат ЗначенияСсылочныхТипов;
КонецФункции

// Параметры:
//   МетаданныеИсточника - ОбъектМетаданныхРегистрБухгалтерии
//
// Возвращаемое значение:
//   Массив
//
Функция СформироватьСтандартныеРеквизитыРегистраБухгалтерии(МетаданныеИсточника)
	СтандартныеРеквизиты = Новый Массив;
	
	СтандартныеРеквизиты.Добавить(Новый Структура("Имя", "Регистратор"));
	Если МетаданныеИсточника.Корреспонденция Тогда
		СтандартныеРеквизиты.Добавить(Новый Структура("Имя","СчетДт"));
		СтандартныеРеквизиты.Добавить(Новый Структура("Имя","СчетКт"));
	Иначе	
		СтандартныеРеквизиты.Добавить(Новый Структура("Имя","Счет"));
	КонецЕсли;
	
	Если МетаданныеИсточника.ПланСчетов.МаксКоличествоСубконто > 0 Тогда
		Если МетаданныеИсточника.Корреспонденция Тогда
			СтандартныеРеквизиты.Добавить(Новый Структура("Имя","СубконтоДт"));
			СтандартныеРеквизиты.Добавить(Новый Структура("Имя","СубконтоКт"));
		Иначе
			СтандартныеРеквизиты.Добавить(Новый Структура("Имя","Субконто"));
		КонецЕсли;
	КонецЕсли;
	
	Возврат СтандартныеРеквизиты;
КонецФункции

Функция СоответствуетОтборуМетаданных( ОтборМетаданных, Элемент)
	Возврат (НЕ ЗначениеЗаполнено(ОтборМетаданных) 
			ИЛИ ОтборМетаданных.Найти(Элемент.Метаданные().ПолноеИмя()) <> Неопределено);
КонецФункции

Функция ЭтоНезависимыйРегистрСведений(МетаданныеИсточника)
	Результат = Истина;
	
	Если НЕ ОбщегоНазначения.ЭтоРегистрСведений(МетаданныеИсточника) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Для каждого СтандартныйРеквизит Из МетаданныеИсточника.СтандартныеРеквизиты Цикл
		Если СтандартныйРеквизит.Имя = "Регистратор" Тогда
			Результат = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

Функция НовыйСсылкиВОбъекте()
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Ссылка");
	Таблица.Колонки.Добавить("Таблица", Новый ОписаниеТипов("Строка"));
	Таблица.Колонки.Добавить("Поле", Новый ОписаниеТипов("Строка"));
	Таблица.Колонки.Добавить("УсловиеОтбора", Новый ОписаниеТипов("Соответствие"));
	
	Возврат Таблица;
КонецФункции

Функция ОписаниеОбъекта(Источник, МетаданныеИсточника)
	Описание = Новый Структура;
	Описание.Вставить("Источник", Источник);
	Описание.Вставить("Таблица", МетаданныеИсточника.ПолноеИмя());
	Описание.Вставить("УсловиеОтбора", Новый Соответствие);
	Описание.УсловиеОтбора.Вставить("Ссылка", Источник.Ссылка);

	Возврат Описание;
КонецФункции

// Параметры:
//   Источник - РегистрСведенийНаборЗаписей
//   МетаданныеИсточника - ОбъектМетаданныхРегистрСведений
//
Функция ОписаниеНабора(Источник, МетаданныеИсточника)
	Описание = Новый Структура;
	Описание.Вставить("Источник", Источник);
	Описание.Вставить("Таблица", МетаданныеИсточника.ПолноеИмя());
	Описание.Вставить("УсловиеОтбора", Новый Соответствие);
	Для каждого Измерение Из МетаданныеИсточника.Измерения Цикл
		Описание.УсловиеОтбора.Вставить(Измерение.Имя);
	КонецЦикла;
	
	Для каждого Реквизит Из МетаданныеИсточника.СтандартныеРеквизиты Цикл
		Если СтрСравнить(Реквизит.Имя, "Период") Тогда
			Описание.УсловиеОтбора.Вставить(Реквизит.Имя);
			Прервать;
		КонецЕсли;
	КонецЦикла;

	Возврат Описание;
КонецФункции

Функция СсылкиДобавленныеПриИзмененииОбъекта(ОписаниеСсылок, СсылкиПометкиУдаления)
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("Ссылка");
	Результат.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	
	РазделительЗапросовПакета = Символы.ПС + "ОБЪЕДИНИТЬ ВСЕ" + Символы.ПС;
	
	ШаблонЗапроса = "
	|ВЫБРАТЬ
	|	&ЗначениеСсылки КАК Ссылка,
	|	ПРЕДСТАВЛЕНИЕ(&ЗначениеСсылки) КАК Представление
	|ГДЕ
	|	НЕ ИСТИНА В (
	|		ВЫБРАТЬ ПЕРВЫЕ 1
	|			ИСТИНА
	|		ИЗ 
	|			#ИмяТаблицы КАК Таблица
	|		ГДЕ
	|			&УсловияОтбораСсылки)";
	
	СчПараметрыСсылок = 0;
	СчПараметрыОтбора = 0;
	
	Запрос = Новый Запрос;
	Для каждого ОбъектЗначениеПометки Из СсылкиПометкиУдаления Цикл
		
		Если НЕ ОбъектЗначениеПометки.Значение Тогда
			Продолжить;
		КонецЕсли;
		
		ЗначениеСсылки =  ОбъектЗначениеПометки.Ключ;
		
		ОписанияСсылки = ОписаниеСсылок.НайтиСтроки(Новый Структура("Ссылка", ЗначениеСсылки));
		Для каждого УдаляемаяСсылка Из ОписанияСсылки Цикл
			ПараметрСсылки = "ЗначениеСсылки" + XMLСтрока(СчПараметрыСсылок);
			ТекстЗапроса = СтрЗаменить(ШаблонЗапроса, "&ЗначениеСсылки", "&" + ПараметрСсылки);
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ИмяТаблицы", УдаляемаяСсылка.Таблица);
			Запрос.Параметры.Вставить(ПараметрСсылки, ЗначениеСсылки);
			
			ТекстУсловия= Новый Массив;
			Для каждого Условие Из УдаляемаяСсылка.УсловиеОтбора Цикл
				ТекстУсловия.Добавить("Таблица." + Условие.Ключ + " = &Параметр" + СчПараметрыОтбора);
				Запрос.Параметры.Вставить("Параметр" + XMLСтрока(СчПараметрыОтбора), Условие.Значение);
				СчПараметрыОтбора= СчПараметрыОтбора + 1;
			КонецЦикла;
			ТекстУсловия.Добавить("Таблица." + УдаляемаяСсылка.Поле + " = &" + ПараметрСсылки);
			ТекстОтбора = СтрСоединить(ТекстУсловия, Символы.ПС + "И" + Символы.НПП);
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловияОтбораСсылки", ТекстОтбора);
			
			Запрос.Текст = Запрос.Текст 
						+ ?(НЕ ПустаяСтрока(Запрос.Текст), РазделительЗапросовПакета, "") 
						+ ТекстЗапроса;
			СчПараметрыСсылок = СчПараметрыСсылок + 1;
		КонецЦикла;
		
	КонецЦикла;
	
	Если НЕ ПустаяСтрока(Запрос.Текст) Тогда
		РезультатЗапроса = Запрос.Выполнить();
		Результат = РезультатЗапроса.Выгрузить();
	КонецЕсли;

	Возврат Результат;
КонецФункции

Функция УдаляемыеСсылкиВКоллекции(ЗначенияСсылочныхТипов)
	
	ВремяСнятияБлокировки = ТекущаяДатаСеанса() - УдалениеПомеченныхОбъектовСлужебный.ВремяЖизниБлокировки();
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	УдаляемыеОбъекты.Объект КАК Ссылка
	|ИЗ
	|	РегистрСведений.УдаляемыеОбъекты КАК УдаляемыеОбъекты
	|ГДЕ
	|	УдаляемыеОбъекты.Объект В(&УдаляемыеОбъекты)
	|	И УдаляемыеОбъекты.ВремяБлокировки >= &ВремяСнятияБлокировки");
	
	Запрос.УстановитьПараметр("УдаляемыеОбъекты", ЗначенияСсылочныхТипов);
	Запрос.УстановитьПараметр("ВремяСнятияБлокировки", ВремяСнятияБлокировки);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ССылка");
	
КонецФункции

#КонецОбласти

#КонецОбласти
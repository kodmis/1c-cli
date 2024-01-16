#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ТекущийКонтейнер;
Перем ТекущийОбъектМетаданных; // ОбъектМетаданных - текущий объект метаданных.
Перем ТекущиеОбработчики;
Перем ТекущийПотокЗаписиПересоздаваемыхСсылок;
Перем ТекущийПотокЗаписиСопоставляемыхСсылок;
Перем ТекущийСериализатор;
Перем ТекущийУзел;

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс


// Инициализирует обработку выгрузки-загрузки данных.
// 
// Параметры:
// 	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - 
// 	ОбъектМетаданных - ОбъектМетаданных -
// 	Узел - ПланОбменаСсылка.МиграцияПриложений - 
// 	Обработчики - ТаблицаЗначений - 
// 	Сериализатор - СериализаторXDTO - 
// 	ПотокЗаписиПересоздаваемыхСсылок - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхПотокЗаписиПересоздаваемыхСсылок - 
// 	ПотокЗаписиСопоставляемыхСсылок - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхПотокЗаписиСопоставляемыхСсылок - 
//
Процедура Инициализировать(Контейнер, ОбъектМетаданных, Узел, Обработчики, Сериализатор, ПотокЗаписиПересоздаваемыхСсылок, ПотокЗаписиСопоставляемыхСсылок) Экспорт
	
	ТекущийКонтейнер = Контейнер;
	ТекущийОбъектМетаданных = ОбъектМетаданных; // ОбъектМетаданных
	ТекущийУзел = Узел;
	ТекущиеОбработчики = Обработчики;
	ТекущийСериализатор = Сериализатор;
	ТекущийПотокЗаписиПересоздаваемыхСсылок = ПотокЗаписиПересоздаваемыхСсылок;
	ТекущийПотокЗаписиСопоставляемыхСсылок = ПотокЗаписиСопоставляемыхСсылок;
  	     
КонецПроцедуры

Процедура ВыгрузитьДанные() Экспорт
	
	Отказ = Ложь;
	ТекущиеОбработчики.ПередВыгрузкойТипа(ТекущийКонтейнер, ТекущийСериализатор, ТекущийОбъектМетаданных, Отказ);
	
	Если Не Отказ Тогда
		ВыгрузитьДанныеОбъектаМетаданных();
	КонецЕсли;
	
	ТекущиеОбработчики.ПослеВыгрузкиТипа(ТекущийКонтейнер, ТекущийСериализатор, ТекущийОбъектМетаданных);
	
КонецПроцедуры

// Выполняет действия для пересоздания ссылки при загрузке.
//
// Параметры:
//	Ссылка - ЛюбаяСсылка - ссылка на объект.
//
Процедура ТребуетсяПересоздатьСсылкуПриЗагрузке(Знач Ссылка) Экспорт
	
	ТекущийПотокЗаписиПересоздаваемыхСсылок.ПересоздатьСсылкуПриЗагрузке(Ссылка);
	
КонецПроцедуры

// Выполняет действия для сопоставления ссылки при загрузке.
//
// Параметры:
//	Ссылка - ЛюбаяСсылка - ссылка на объект.
//	ЕстественныйКлюч - Структура - где ключ, это имя естественного ключа, а значение произвольное значение естественного ключа.
//
Процедура ТребуетсяСопоставитьСсылкуПриЗагрузке(Знач Ссылка, Знач ЕстественныйКлюч) Экспорт
	
	ТекущийПотокЗаписиСопоставляемыхСсылок.СопоставитьСсылкуПриЗагрузке(Ссылка, ЕстественныйКлюч);
	
КонецПроцедуры

Процедура Закрыть() Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВыгрузитьДанныеОбъектаМетаданных()
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Выгрузка загрузка данных. Выгрузка объекта метаданных'", ОбщегоНазначения.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Информация,
		ТекущийОбъектМетаданных,
		,
		СтрШаблон(НСтр("ru = 'Начало выгрузки данных объекта метаданных: %1'", ОбщегоНазначения.КодОсновногоЯзыка()),
			ТекущийОбъектМетаданных.ПолноеИмя()));
	
	Если ОбщегоНазначенияБТС.ЭтоКонстанта(ТекущийОбъектМетаданных) Тогда
		
		ВыгрузитьКонстанту();
		
	ИначеЕсли ОбщегоНазначенияБТС.ЭтоСсылочныеДанные(ТекущийОбъектМетаданных) Тогда
		
		ВыгрузитьСсылочныйОбъект();
		
	ИначеЕсли ОбщегоНазначенияБТС.ЭтоНезависимыйНаборЗаписей(ТекущийОбъектМетаданных) Тогда
		
		ВыгрузитьНезависимыйНаборЗаписей();
		
	ИначеЕсли ОбщегоНазначенияБТС.ЭтоНаборЗаписей(ТекущийОбъектМетаданных) Тогда 
		
		ВыгрузитьНаборЗаписейПодчиненныйРегистратору();
		
	Иначе
		
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Неожиданный объект метаданных: %1'"),
			ТекущийОбъектМетаданных.ПолноеИмя());
		
	КонецЕсли;
 	
КонецПроцедуры

// Выгружает константу.
//
// Параметры:
//	ПотокЗаписи - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхПотокЗаписиДанныхИнформационнойБазы - поток для записи.
//
Процедура ВыгрузитьКонстанту()
	
	Если ТекущийУзел = Неопределено Тогда
	
		МенеджерЗначения = Константы[ТекущийОбъектМетаданных.Имя].СоздатьМенеджерЗначения();	
		МенеджерЗначения.Прочитать();
		
		ПотокЗаписи = НачатьЗаписьФайла();
		ЗаписатьДанныеИнформационнойБазы(ПотокЗаписи, МенеджерЗначения);
		ЗавершитьЗаписьФайла(ПотокЗаписи);
		
	Иначе
		
		Выборка = ПланыОбмена.ВыбратьИзменения(ТекущийУзел, 1, Метаданные.Константы.ЗаголовокСистемы);
		Пока Выборка.Следующий() Цикл
			
			МенеджерЗначения = Выборка.Получить();
			
			ПотокЗаписи = НачатьЗаписьФайла();
			ЗаписатьДанныеИнформационнойБазы(ПотокЗаписи, МенеджерЗначения);
			ЗавершитьЗаписьФайла(ПотокЗаписи);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Выгружает ссылочный объект.
//
// Параметры:
//	ПотокЗаписи - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхПотокЗаписиПересоздаваемыхСсылок - поток записи.
//
Процедура ВыгрузитьСсылочныйОбъект()
	
	ПотокЗаписи = НачатьЗаписьФайла();
	
	ИмяОбъекта = ТекущийОбъектМетаданных.ПолноеИмя();
	Если ТекущийУзел = Неопределено 
		Или Метаданные.ПланыОбмена.Содержит(ТекущийОбъектМетаданных) Тогда
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ИмяОбъекта);
	
		Выборка = МенеджерОбъекта.Выбрать();
		Пока Выборка.Следующий() Цикл
			Объект = Выборка.ПолучитьОбъект();
			ЗаписатьДанныеИнформационнойБазы(ПотокЗаписи, Объект);
		КонецЦикла;
		
	Иначе
		
		Выборка = ПланыОбмена.ВыбратьИзменения(ТекущийУзел, 1, ТекущийОбъектМетаданных);
		Пока Выборка.Следующий() Цикл
			Объект = Выборка.Получить();
			ЗаписатьДанныеИнформационнойБазы(ПотокЗаписи, Объект);
		КонецЦикла;
	
	КонецЕсли;
	
	ЗавершитьЗаписьФайла(ПотокЗаписи);
	
КонецПроцедуры

// Выгружает независимый набор записей, с помощью курсорного (постраничного) запроса.
//
// Параметры:
//	ПотокЗаписи - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхПотокЗаписиДанныхИнформационнойБазы - поток для записи. 
//
Процедура ВыгрузитьНезависимыйНаборЗаписей()
	
	ПотокЗаписи = НачатьЗаписьФайла();
	
	Если ТекущийУзел = Неопределено Тогда
		
		Измерения = Новый Массив();
		Если ТекущийОбъектМетаданных.ПериодичностьРегистраСведений 
			<> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический Тогда
			РеквизитПериод = ТекущийОбъектМетаданных.СтандартныеРеквизиты.Период; // ОписаниеСтандартногоРеквизита
			Измерения.Добавить(РеквизитПериод.Имя);
		КонецЕсли;
		Для Каждого Измерение Из ТекущийОбъектМетаданных.Измерения Цикл // ОбъектМетаданныхИзмерение
			Измерения.Добавить(Измерение.Имя);
		КонецЦикла;
		
		МенеджерОбъекта = РегистрыСведений[ТекущийОбъектМетаданных.Имя];
		НаборЗаписей = МенеджерОбъекта.СоздатьНаборЗаписей(); // Создание набора занимает существенное время
		Для Каждого Измерение Из Измерения Цикл
			НаборЗаписей.Отбор[Измерение].Использование = Истина;
		КонецЦикла;
		
		Выборка = МенеджерОбъекта.Выбрать();
		Пока Выборка.Следующий() Цикл
			НаборЗаписей.Очистить();
			Для Каждого Измерение Из Измерения Цикл
				НаборЗаписей.Отбор[Измерение].Значение = Выборка[Измерение];
			КонецЦикла;
			ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), Выборка);
			ЗаписатьДанныеИнформационнойБазы(ПотокЗаписи, НаборЗаписей);
		КонецЦикла;
			
	Иначе
		
		Выборка = ПланыОбмена.ВыбратьИзменения(ТекущийУзел, 1, ТекущийОбъектМетаданных);
		Пока Выборка.Следующий() Цикл
			
			НаборЗаписей = Выборка.Получить();
			ЗаписатьДанныеИнформационнойБазы(ПотокЗаписи, НаборЗаписей);
			
		КонецЦикла;
		
	КонецЕсли;
	
	ЗавершитьЗаписьФайла(ПотокЗаписи);
	
КонецПроцедуры

// Выгружает набор записей, подчиненный регистратору.
//
// Параметры:
//	ПотокЗаписи - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхПотокЗаписиДанныхИнформационнойБазы - поток для записи.
//
Процедура ВыгрузитьНаборЗаписейПодчиненныйРегистратору()
	
	Если ОбщегоНазначенияБТС.ЭтоНаборЗаписейПерерасчета(ТекущийОбъектМетаданных) Тогда
		
		ИмяПоляРегистратора = "ОбъектПерерасчета";
		
		Подстроки = СтрРазделить(ТекущийОбъектМетаданных.ПолноеИмя(), ".");
		ИмяТаблицы = Подстроки[0] + "." + Подстроки[1] + "." + Подстроки[3];
		
	Иначе
		
		ИмяПоляРегистратора = "Регистратор";
		ИмяТаблицы = ТекущийОбъектМетаданных.ПолноеИмя();
		
	КонецЕсли;
	
	ПотокЗаписи = НачатьЗаписьФайла();
	
	Если ТекущийУзел <> Неопределено Тогда
		
		Выборка = ПланыОбмена.ВыбратьИзменения(ТекущийУзел, 1, ТекущийОбъектМетаданных);
		Пока Выборка.Следующий() Цикл
			
			НаборЗаписей = Выборка.Получить();
			ЗаписатьДанныеИнформационнойБазы(ПотокЗаписи, НаборЗаписей);
			
		КонецЦикла;
	
	ИначеЕсли ОбщегоНазначенияБТС.ЭтоРегистрНакопления(ТекущийОбъектМетаданных)
		Или ОбщегоНазначенияБТС.ЭтоРегистрСведений(ТекущийОбъектМетаданных) Тогда
			
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Таблица.ИмяПоляРегистратора КАК Регистратор,
		|	КОЛИЧЕСТВО(*) КАК КоличествоЗаписей
		|ИЗ
		|	ИмяТаблицы КАК Таблица
		|СГРУППИРОВАТЬ ПО
		|	Таблица.ИмяПоляРегистратора";
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ИмяТаблицы", ИмяТаблицы);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ИмяПоляРегистратора", ИмяПоляРегистратора);
		Результат = Запрос.Выполнить();
		Если Результат.Пустой() Тогда
			ЗавершитьЗаписьФайла(ПотокЗаписи);
			Возврат;
		КонецЕсли;
		
		НаборыРегистраторов = Новый Массив;
		НаборыРегистраторов.Добавить(Новый Массив);
		Выборка = Результат.Выбрать();
		ТекущееКоличествоЗаписей = 0;
		Пока Выборка.Следующий() Цикл
			Если ТекущееКоличествоЗаписей + Выборка.КоличествоЗаписей > 1000 И ТекущееКоличествоЗаписей <> 0 Тогда
				НаборыРегистраторов.Добавить(Новый Массив);
				ТекущееКоличествоЗаписей = 0;
			КонецЕсли;
			ТекущееКоличествоЗаписей = ТекущееКоличествоЗаписей + Выборка.КоличествоЗаписей;
			НаборыРегистраторов[НаборыРегистраторов.ВГраница()].Добавить(Выборка.Регистратор);
		КонецЦикла;
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	*
		|ИЗ
		|	ИмяТаблицы КАК Таблица
		|ГДЕ
		|	Регистратор В (&Регистраторы)
		|УПОРЯДОЧИТЬ ПО
		|	Регистратор, НомерСтроки
		|ИТОГИ ПО
		|	Регистратор";
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ИмяТаблицы", ИмяТаблицы);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ИмяПоляРегистратора", ИмяПоляРегистратора);
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ТекущийОбъектМетаданных.ПолноеИмя());
		НаборЗаписей = МенеджерОбъекта.СоздатьНаборЗаписей(); // Создание набора занимает существенное время
		Для Каждого Регистраторы Из НаборыРегистраторов Цикл
			Запрос.УстановитьПараметр("Регистраторы", Регистраторы);
			ВыборкаПоРегистраторам = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаПоРегистраторам.Следующий() Цикл
				НаборЗаписей.Очистить();
				ЭлементОтбора = НаборЗаписей.Отбор[ИмяПоляРегистратора]; // ЭлементОтбора
				ЭлементОтбора.Установить(ВыборкаПоРегистраторам.Регистратор);
				ВыборкаПоЗаписям = ВыборкаПоРегистраторам.Выбрать();
				Пока ВыборкаПоЗаписям.Следующий() Цикл
					ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), ВыборкаПоЗаписям);
				КонецЦикла;
				ЗаписатьДанныеИнформационнойБазы(ПотокЗаписи, НаборЗаписей);
			КонецЦикла;
		КонецЦикла;
		
	Иначе
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Таблица.ИмяПоляРегистратора КАК Регистратор
		|ИЗ
		|	ИмяТаблицы КАК Таблица";
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ИмяТаблицы", ИмяТаблицы);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ИмяПоляРегистратора", ИмяПоляРегистратора);
		
		Результат = Запрос.Выполнить();
		Если Результат.Пустой() Тогда
			ЗавершитьЗаписьФайла(ПотокЗаписи);
			Возврат;
		КонецЕсли;
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ТекущийОбъектМетаданных.ПолноеИмя());
		НаборЗаписей = МенеджерОбъекта.СоздатьНаборЗаписей(); // Создание набора занимает существенное время
		
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			ЭлементОтбора = НаборЗаписей.Отбор[ИмяПоляРегистратора]; // ЭлементОтбора
			ЭлементОтбора.Установить(Выборка.Регистратор);
			
			НаборЗаписей.Прочитать();
			
			ЗаписатьДанныеИнформационнойБазы(ПотокЗаписи, НаборЗаписей);
			
		КонецЦикла;
	
	КонецЕсли;
	
	ЗавершитьЗаписьФайла(ПотокЗаписи);
	
КонецПроцедуры

// Записывает объект в XML.
//
// Параметры:
//	ПотокЗаписи - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхПотокЗаписиДанныхИнформационнойБазы - поток для записи. 
//	Данные - Произвольный - записываемый объект.
//
Процедура ЗаписатьДанныеИнформационнойБазы(ПотокЗаписи, Данные)
	
	Отказ = Ложь;
	Артефакты = Новый Массив();
	ТекущиеОбработчики.ПередВыгрузкойОбъекта(ТекущийКонтейнер, ЭтотОбъект, ТекущийСериализатор, Данные, Артефакты, Отказ);
	
	Если Не Отказ Тогда
		ПотокЗаписи.ЗаписатьОбъектДанныхИнформационнойБазы(Данные, Артефакты);
	КонецЕсли;
	
	ТекущиеОбработчики.ПослеВыгрузкиОбъекта(ТекущийКонтейнер, ЭтотОбъект, ТекущийСериализатор, Данные, Артефакты);
	
	Если ПотокЗаписи.РазмерБольшеРекомендуемого() Тогда
		ЗавершитьЗаписьФайла(ПотокЗаписи);
		ПотокЗаписи = НачатьЗаписьФайла();
	КонецЕсли;
	
КонецПроцедуры

Функция НачатьЗаписьФайла()
	
	ИмяФайла = ТекущийКонтейнер.СоздатьФайл(
		ВыгрузкаЗагрузкаДанныхСлужебный.InfobaseData(), ТекущийОбъектМетаданных.ПолноеИмя());
	
	ПотокЗаписи = Обработки.ВыгрузкаЗагрузкаДанныхПотокЗаписиДанныхИнформационнойБазы.Создать();
	ПотокЗаписи.ОткрытьФайл(ИмяФайла, ТекущийСериализатор);
	
	Возврат ПотокЗаписи;
	
КонецФункции

Процедура ЗавершитьЗаписьФайла(ПотокЗаписи)
	
	ПотокЗаписи.Закрыть();
	
	КоличествоОбъектов = ПотокЗаписи.КоличествоОбъектов();
	Если КоличествоОбъектов = 0 Тогда
		ТекущийКонтейнер.ИсключитьФайл(ПотокЗаписи.ИмяФайла());
	Иначе
		ТекущийКонтейнер.УстановитьКоличествоОбъектов(ПотокЗаписи.ИмяФайла(), КоличествоОбъектов);
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Выгрузка загрузка данных. Выгрузка объекта метаданных'", ОбщегоНазначения.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Информация,
		ТекущийОбъектМетаданных,
		,
		СтрШаблон(НСтр("ru = 'Окончание выгрузки данных объекта метаданных: %1
		|Выгружено объектов: %2'", ОбщегоНазначения.КодОсновногоЯзыка()),
			ТекущийОбъектМетаданных.ПолноеИмя(), КоличествоОбъектов));
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

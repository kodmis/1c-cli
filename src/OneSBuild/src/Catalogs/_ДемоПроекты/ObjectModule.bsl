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

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Таблица - см. УправлениеДоступом.ТаблицаНаборыЗначенийДоступа
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	// Логика ограничения:
	// Чтения:     Организация
	// Изменения:  Организация И Ответственный (если ответственный заполнен).
	
	Если Не ЗначениеЗаполнено(Ответственный) Тогда
		// Чтение, Изменение.
		Строка = Таблица.Добавить();
		Строка.ЗначениеДоступа = Организация;
	Иначе
		// Чтение: набор №1.
		Строка = Таблица.Добавить();
		Строка.НомерНабора     = 1;
		Строка.Чтение          = Истина;
		Строка.ЗначениеДоступа = Организация;
		
		// Добавление, Изменение: набор №2.
		Строка = Таблица.Добавить();
		Строка.НомерНабора     = 2;
		Строка.Изменение       = Истина;
		Строка.ЗначениеДоступа = Организация;
		
		Строка = Таблица.Добавить();
		Строка.НомерНабора     = 2;
		Строка.ЗначениеДоступа = Ответственный;
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
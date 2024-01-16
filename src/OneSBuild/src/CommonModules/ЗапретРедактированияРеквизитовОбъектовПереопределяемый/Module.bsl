///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определить объекты метаданных, в модулях менеджеров которых ограничивается возможность
// редактирования реквизитов с помощью экспортной функции ПолучитьБлокируемыеРеквизитыОбъекта.
//
// Функция ПолучитьБлокируемыеРеквизитыОбъекта должна возвращать значение Массив - строки в формате
// ИмяРеквизита[;ИмяЭлементаФормы,...], где ИмяРеквизита - имя реквизита объекта, ИмяЭлементаФормы -
// имя элемента формы, связанного с реквизитом. Например: "Объект.Автор", "ПолеАвтор".
//
// Поле надписи, связанное с реквизитом, не блокируется. Если требуется блокировать,
// имя элемента надписи нужно указать после точки с запятой, как написано выше.
//
// Параметры:
//   Объекты - Соответствие из КлючИЗначение:
//     * Ключ - Строка - полное имя объекта метаданных, подключенного к подсистеме;
//     * Значение - Строка - пустая строка.
//
// Пример:
//   Объекты.Вставить(Метаданные.Документы.ЗаказПокупателя.ПолноеИмя(), "");
//
//   При этом в модуле менеджера документа ЗаказПокупателя размещается код:
//   // См. ЗапретРедактированияРеквизитовОбъектовПереопределяемый.ПриОпределенииОбъектовСЗаблокированнымиРеквизитами.
//   Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
//   	БлокируемыеРеквизиты = Новый Массив;
//   	БлокируемыеРеквизиты.Добавить("Организация"); // заблокировать редактирование реквизита Организация
//   	Возврат БлокируемыеРеквизиты;
//   КонецФункции
//
Процедура ПриОпределенииОбъектовСЗаблокированнымиРеквизитами(Объекты) Экспорт
	
	// _Демо начало примера
	_ДемоСтандартныеПодсистемы.ПриОпределенииОбъектовСЗаблокированнымиРеквизитами(Объекты);
	// _Демо конец примера
	
КонецПроцедуры

// Позволяет переопределить список заблокированных реквизитов, заданных в модуле менеджера объекта.
//
// Параметры:
//   ИмяОбъектаМетаданных - Строка - например, "Справочник.Файлы".
//   ЗаблокированныеРеквизиты - Массив из Строка - строки в формате "ИмяРеквизита[;ИмяЭлементаФормы,...]", 
//                              где ИмяРеквизита - имя реквизита объекта, ИмяЭлементаФормы -
//                              имя элемента формы, связанного с реквизитом. Например: "Объект.Автор", "ПолеАвтор".
//
Процедура ПриОпределенииЗаблокированныхРеквизитов(ИмяОбъектаМетаданных, ЗаблокированныеРеквизиты) Экспорт
	
КонецПроцедуры

#КонецОбласти

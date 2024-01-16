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

// СтандартныеПодсистемы.ПодключаемыеКоманды

// Определяет состав программного интерфейса для интеграции с конфигурацией.
//
// Параметры:
//   Настройки - Структура - настройки интеграции этого объекта:
//     * ДобавитьКомандыОтправкиПриглашения - Булево
//     * Размещение - Массив из Строка
//
Процедура ПриОпределенииНастроек(Настройки) Экспорт
	
	Настройки.ДобавитьКомандыОтправкиПриглашения = Истина;
	Настройки.Размещение.Добавить(Метаданные.Документы.НазначениеОпросов);
	
КонецПроцедуры

// Определяет список подключаемых команд для вывода в подменю "ПодменюОтправкаПриглашенияДляАнкетирования" у объектов конфигурации.
// Описание параметров подменю см. ПодключаемыеКомандыПереопределяемый.ПриОпределенииВидовПодключаемыхКоманд.
//
// Параметры:
//   Команды - ТаблицаЗначений - таблица описывающая команды, куда необходимо добавить собственные подключаемые команды.
//                               Состав колонок см. в описании параметра Команды процедуры
//                               ПодключаемыеКомандыПереопределяемый.ПриОпределенииКомандПодключенныхКОбъекту.
//   Параметры - Структура - вспомогательные входные параметры, необходимые для формирования команд.
//       См. описание параметра НастройкиФормы процедуры ПодключаемыеКомандыПереопределяемый.ПриОпределенииКомандПодключенныхКОбъекту.
//
Процедура ДобавитьКомандыОтправкиПриглашения(Команды, Параметры) Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьШаблоныСообщений") 
		И ПравоДоступа("Просмотр", Метаданные.Обработки._ДемоОтправкаПриглашенияДляАнкетирования) Тогда
		Команда                  = Команды.Добавить();
		Команда.Представление    = НСтр("ru = 'Пригласить'");
		Команда.Идентификатор    = "ОтправитьПриглашениеДляАнкетирования";
		Команда.Обработчик       = "ОтправитьПриглашениеДляАнкетирования";
		Команда.ИмяФормы         =  "Обработка._ДемоОтправкаПриглашенияДляАнкетирования.Форма";
		Команда.Вид              = "ОтправкаПриглашенияДляАнкетирования";
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Параметры:
//  ПараметрыВызоваСервера - ЛюбаяСсылка
//  АдресХранилища - Строка
//
Процедура СформироватьИОтправитьПисьмо(ПараметрыВызоваСервера, АдресХранилища) Экспорт
	
	УчетныеЗаписи = РаботаСПочтовымиСообщениями.ДоступныеУчетныеЗаписи(Истина);
	Если УчетныеЗаписи.Количество() = 0 Тогда
		ОписаниеОшибки = НСтр("ru = 'Учетная запись не заполнена или содержит некорректные сведения.'");
		ЗаполнитьРезультат(АдресХранилища, ОписаниеОшибки);
		Возврат;
	Иначе
		УчетнаяЗапись = УчетныеЗаписи[0].Ссылка;
	КонецЕсли;
	
	ВладелецШаблона = ?(ТипЗнч(ПараметрыВызоваСервера.Ссылка) = Тип("Массив"), ПараметрыВызоваСервера.Ссылка[0], ПараметрыВызоваСервера.Ссылка);
	
	Шаблон = ШаблоныСообщений.ПараметрыШаблона(ВладелецШаблона);
	УникальныйИдентификатор = Неопределено;
	Сообщение = ШаблоныСообщений.СформироватьСообщение(Шаблон.Ссылка, ВладелецШаблона, УникальныйИдентификатор);
	Получатели = ПолучателиПриглашения(ВладелецШаблона);
	
	ПараметрыПисьма = Новый Структура();
	ПараметрыПисьма.Вставить("СкрытыеКопии", Получатели);
	ПараметрыПисьма.Вставить("Тема", Сообщение.Тема);
	ПараметрыПисьма.Вставить("Тело", Сообщение.Текст);
	
	ТипТекста = ?(Сообщение.ДополнительныеПараметры.ФорматПисьма = Перечисления.СпособыРедактированияЭлектронныхПисем.HTML, "HTML", "ПростойТекст");
	ПараметрыПисьма.Вставить("ТипТекста", ТипТекста);
	ПараметрыПисьма.Вставить("Вложения", ОбщегоНазначения.ТаблицаЗначенийВМассив(Сообщение.Вложения));
	
	Письмо = РаботаСПочтовымиСообщениями.ПодготовитьПисьмо(УчетнаяЗапись, ПараметрыПисьма);
	Попытка
		РаботаСПочтовымиСообщениями.ОтправитьПисьмо(УчетнаяЗапись, Письмо);
	Исключение
		ЗаполнитьРезультат(АдресХранилища, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат;
	КонецПопытки;
	
	ЗаполнитьРезультат(АдресХранилища)
	
КонецПроцедуры

Процедура ЗаполнитьРезультат(АдресХранилища, ОписаниеОшибки = "")
	
	Результат = Новый Структура("Успешно, ОписаниеОшибки", Истина);
	Если НЕ ПустаяСтрока(ОписаниеОшибки) Тогда
		Результат.Успешно = Ложь;
		Результат.ОписаниеОшибки = ОписаниеОшибки;
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);
	
КонецПроцедуры

Функция ПолучателиПриглашения(Знач ВладелецШаблона)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НазначениеОпросовРеспонденты.Респондент КАК Респондент
	|ИЗ
	|	Документ.НазначениеОпросов.Респонденты КАК НазначениеОпросовРеспонденты
	|ГДЕ
	|	НазначениеОпросовРеспонденты.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ВладелецШаблона);
	Респонденты = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Респондент");
	
	ТипыКонтактнойИнформации = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
	ЭлектроннаяПочтаРеспондентов = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъектов(Респонденты, ТипыКонтактнойИнформации);
	Получатели = Новый Массив;
	Для каждого Получатель Из ЭлектроннаяПочтаРеспондентов Цикл
		Получатели.Добавить(Новый Структура("Адрес, Представление", Получатель.Представление, Строка(Получатель.Объект)));
	КонецЦикла;
	
	Возврат Получатели;

КонецФункции

#КонецОбласти

#КонецЕсли
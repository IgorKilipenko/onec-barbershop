﻿#Область ПрограммныйИнтерфейс

// Заполняет поле АвторДокумента
//
// Параметры:
//  объект - Структура - Документ или представление Документа
//
Процедура ЗаполнитьПолеАвторДокументаНаСервере(объект) Экспорт
	объект.АвторДокумента = ?(ЗначениеЗаполнено(объект.АвторДокумента),
			объект.АвторДокумента, ПараметрыСеанса.ТекущийПользователь);
КонецПроцедуры

// Параметры:
//	контрагентСсылка
//		- СправочникСсылка.Контрагенты
//		- Произвольный
//
// Возвращаемое значение:
//	- Булево
Функция ЭтоКлиент(Знач контрагентСсылка) Экспорт // => Булево

	Если (контрагентСсылка = Неопределено) ИЛИ (ТипЗнч(контрагентСсылка) <> Тип("СправочникСсылка.Контрагенты")) Тогда
		Возврат Ложь;
	КонецЕсли;

	запросКонтрагента = Новый Запрос;
	запросКонтрагента.УстановитьПараметр("Ссылка", контрагентСсылка);

	запросКонтрагента.Текст =
		"ВЫБРАТЬ
		|	Контрагенты.ТипКонтрагента КАК ТипКонтрагента,
		|	Контрагенты.Ссылка КАК Контрагент
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|ГДЕ
		|	Контрагенты.Ссылка = &Ссылка
		|";

	результатЗапроса = запросКонтрагента.Выполнить();
	Если результатЗапроса.Пустой() Тогда
		Возврат Ложь;
	КонецЕсли;

	контрагентВыборка = результатЗапроса.Выбрать();
	контрагентВыборка.Следующий();

	Если ЗначениеЗаполнено(контрагентВыборка.ТипКонтрагента)
		И контрагентВыборка.ТипКонтрагента = Перечисления.ТипыКонтрагентов.Клиент Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
КонецФункции

// Возвращает структуру с именами (ключ) и значениями из Перечисления.ВидыОперацийРасходаДенег
//
// Возвращаемое значение:
//	- Структура
//
Функция ПолучитьВидыОперацийРасходаДенег() Экспорт
	результат = Новый Структура;
	Для Каждого значениеПеречисления Из Метаданные.Перечисления.ВидыОперацийРасходаДенег.ЗначенияПеречисления Цикл
		имя_ = значениеПеречисления.Имя;
		результат.Вставить(имя_, Перечисления.ВидыОперацийРасходаДенег[имя_]);
	КонецЦикла;

	Возврат результат;
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

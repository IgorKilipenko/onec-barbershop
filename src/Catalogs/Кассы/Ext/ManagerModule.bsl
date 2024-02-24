﻿#Область ПрограммныйИнтерфейс

// Возвращаемое значение:
//	- СправочникСсылка.Кассы, Неопределено
Функция ПолучитьОсновнуюКассу() Экспорт
	запрос = Новый Запрос;
	запрос.УстановитьПараметр("НаименованиеКассы", "Основная");

	запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Кассы.Ссылка КАК Ссылка
	|ИЗ Справочник.Кассы КАК Кассы
	|ГДЕ Кассы.Наименование = &НаименованиеКассы
	|";

	результат = запрос.Выполнить();

	Если результат.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;

	выборка = результат.Выбрать();
	выборка.Следующий();

	Возврат выборка.Ссылка;

КонецФункции

// Параметры:
//	кассаСсылка - СправочникСсылка.Кассы
//	моментВремени - МоментВремени, Неопределено
// Возвращаемое значение:
//	- Структура - Структура вида: { Касса: Строка, Сумма: Число }
//  - Неопределено - Если в РегистрНакопления.ДенежныеСредства нет записи с указанной кассой
Функция ПолучитьОстатокДенежныхСредствПоКассе(Знач кассаСсылка, Знач моментВремени = Неопределено) Экспорт
    Возврат РегистрыНакопления.ДенежныеСредства.ПолучитьОстатокПоКассе(кассаСсылка, моментВремени);
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

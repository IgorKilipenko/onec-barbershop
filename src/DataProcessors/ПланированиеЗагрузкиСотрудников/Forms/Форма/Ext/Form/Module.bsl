﻿#Область ОписанияПеременных

&НаКлиенте
Перем _ВариантыИзмененияПериода;

&НаКлиенте
Перем _ВариантыПериодов;

#КонецОбласти // ОписанияПеременных

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(_, __)
	заполнитьПланировщикНаСервере();
	установитьНастройкиОтображениеПланировщикаНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии()
	инициализация();
	установитьПредставлениеПериода(_ВариантыИзмененияПериода.Сегодня);
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВариантПериодаПриИзменении(_)
	установитьПредставлениеПериода(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ПланировщикПередСозданием(_, начало, конец, значенияИзмерений, __, стандартнаяОбработка)
	стандартнаяОбработка = Ложь;
	параметрыОткрытияФормы = Новый Структура("Начало, Окончание, Сотрудник", начало, конец, значенияИзмерений.Получить("Сотрудники"));
	ОткрытьФорму("Документ.ЗаписьКлиента.Форма.ФормаДокумента", параметрыОткрытияФормы, , ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПланировщикПриСменеТекущегоПериодаОтображения(_, __, стандартнаяОбработка)
	стандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ПланировщикПередНачаломБыстрогоРедактирования(элемент, стандартнаяОбработка)
	стандартнаяОбработка = Ложь;
	параметрыОткрытияФормы = Новый Структура("Ключ", элемент.ВыделенныеЭлементы[0].Значение);

	ОткрытьФорму("Документ.ЗаписьКлиента.Форма.ФормаДокумента", параметрыОткрытияФормы, , ЭтотОбъект);
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовШапкиФормы

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Вперед(_)
	установитьПредставлениеПериода(_ВариантыИзмененияПериода.Вперед);
КонецПроцедуры

&НаКлиенте
Процедура Назад(_)
	установитьПредставлениеПериода(_ВариантыИзмененияПериода.Назад);
КонецПроцедуры

&НаКлиенте
Процедура Сегодня(_)
	установитьПредставлениеПериода(_ВариантыИзмененияПериода.Сегодня);
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура заполнитьПланировщикНаСервере()
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ЗаписьКлиента.Сотрудник КАК Сотрудник,
		|	ЗаписьКлиента.Сотрудник.Представление КАК СотрудникПредставление,
		|	ЗаписьКлиента.ДатаЗаписи КАК ДатаЗаписи,
		|	ЗаписьКлиента.ДатаОкончанияЗаписи КАК ДатаОкончанияЗаписи,
		|	ЗаписьКлиента.Клиент.Представление КАК КлиентПредставление,
		|	ЗаписьКлиента.Ссылка КАК ЗаписьКлиента,
		|	ЗаписьКлиента.УслугаОказана КАК УслугаОказана
		|ИЗ
		|	Документ.ЗаписьКлиента КАК ЗаписьКлиента
		|ГДЕ
		|	ЗаписьКлиента.Проведен
		|ИТОГИ ПО
		|	Сотрудник
		|";

	измеренияПланировщика = Планировщик.Измерения;
	измеренияПланировщика.Очистить();

	результатЗапроса = Запрос.Выполнить();
	выборкаСотрудники = результатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	измерениеСотрудники = измеренияПланировщика.Добавить("Сотрудники");
	Пока выборкаСотрудники.Следующий() Цикл
		новоеИзмерение = измерениеСотрудники.Элементы.Добавить(выборкаСотрудники.Сотрудник);
		новоеИзмерение.Текст = выборкаСотрудники.СотрудникПредставление;

		выборка = выборкаСотрудники.Выбрать();
		Пока выборка.Следующий() Цикл
			датаНачала = выборка.ДатаЗаписи;
			датаОкончания = ?(ЗначениеЗаполнено(выборка.ДатаОкончанияЗаписи), выборка.ДатаОкончанияЗаписи, выборка.ДатаЗаписи + 60 * 60);

			соответствиеЗначений = Новый Соответствие;
			соответствиеЗначений.Вставить("Сотрудники", выборка.Сотрудник);

			новыйЭлемент = Планировщик.Элементы.Добавить(датаНачала, датаОкончания);
			новыйЭлемент.Текст = СокрЛП(выборка.КлиентПредставление);
			новыйЭлемент.Значение = выборка.ЗаписьКлиента;

			Если выборка.УслугаОказана Тогда
				новыйЭлемент.ЦветФона = WebЦвета.ЗеленаяЛужайка;
			Иначе
				новыйЭлемент.ЦветФона = WebЦвета.Бирюзовый;
			КонецЕсли;

			новыйЭлемент.ЦветРамки = WebЦвета.Черный;
			новыйЭлемент.ЗначенияИзмерений = Новый ФиксированноеСоответствие(соответствиеЗначений);
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура установитьПредставлениеПериода(Знач вариантИзмененияПериода = Неопределено)
	ДиагностикаКлиентСервер.Утверждение(вариантИзмененияПериода = Неопределено
			ИЛИ вариантИзмененияПериода = _ВариантыИзмененияПериода.Назад
			ИЛИ вариантИзмененияПериода = _ВариантыИзмененияПериода.Вперед
			ИЛИ вариантИзмененияПериода = _ВариантыИзмененияПериода.Сегодня,
			СтрШаблон("Аргумент ""%1"" имеет недопустимое значение", "ВариантИзмененияПериода"),
			"ПланированиеЗагрузкиСотрудников.Форма.установитьПредставлениеПериода");

	датаСейчас = получитьТекущуюДатуНаСервере();
	текущийПериодПланировщика = ЭтотОбъект.Планировщик.ТекущиеПериодыОтображения[0];

	Если НЕ ЗначениеЗаполнено(текущийПериодПланировщика.Начало) Тогда
		текущийПериодПланировщика.Начало = датаСейчас;
	КонецЕсли;

	числоПериодов = ?(вариантИзмененияПериода = Неопределено ИЛИ вариантИзмененияПериода = _ВариантыИзмененияПериода.Сегодня, 0,
			?(вариантИзмененияПериода = _ВариантыИзмененияПериода.Вперед, 1, -1));

	датаНачала = ?(вариантИзмененияПериода = _ВариантыИзмененияПериода.Сегодня, датаСейчас, текущийПериодПланировщика.Начало);
	датаОкончания = датаНачала;

	Если ЭтотОбъект.ВариантПериода = _ВариантыПериодов.День Тогда
		датаНачала = добавитьРабочийДень(НачалоДня(датаНачала), числоПериодов);
		датаОкончания = КонецДня(датаНачала);
		ЭтотОбъект.ПредставлениеПериода = Формат(датаНачала, "ДФ='дд ММММ'");

	ИначеЕсли ЭтотОбъект.ВариантПериода = _ВариантыПериодов.Неделя Тогда
		датаНачала = добавитьРабочуюНеделю(НачалоНедели(датаНачала), числоПериодов);
		датаОкончания = КонецНедели(датаНачала);
		ЭтотОбъект.ПредставлениеПериода = СтрШаблон("%1 - %2", Формат(датаНачала, "ДФ='дд ММММ'"), Формат(датаОкончания, "ДФ='дд ММММ гггг'"));

	ИначеЕсли ЭтотОбъект.ВариантПериода = _ВариантыПериодов.Месяц Тогда
		датаНачала = добавитьРабочийМесяц(НачалоМесяца(датаНачала), числоПериодов);
		датаОкончания = КонецМесяца(датаНачала);
		ЭтотОбъект.ПредставлениеПериода = ПредставлениеПериода(датаНачала, датаОкончания);
	КонецЕсли;

	Планировщик.ТекущиеПериодыОтображения.Очистить();
	ЭтотОбъект.Планировщик.ТекущиеПериодыОтображения.Добавить(датаНачала, датаОкончания);
КонецПроцедуры

&НаКлиенте
Функция добавитьРабочийДень(Знач исходнаяДата, Знач числоДней)
	деньСекунд = 60 * 60 * 24;
	Возврат исходнаяДата + числоДней * деньСекунд;
КонецФункции

&НаКлиенте
Функция добавитьРабочуюНеделю(Знач исходнаяДата, Знач числоНедель)
	неделяСекунд = 60 * 60 * 24 * 7;
	Возврат исходнаяДата + числоНедель * неделяСекунд;
КонецФункции

&НаКлиенте
Функция добавитьРабочийМесяц(Знач исходнаяДата, Знач числоМесяцев)
	Возврат ДобавитьМесяц(исходнаяДата, числоМесяцев);
КонецФункции

&НаСервереБезКонтекста
Функция получитьПериодРабочегоДняНаСервере()
	результат = Новый Структура;
	результат.Вставить("НачалоРабочегоДня", Константы.НачалоРабочегоДня.Получить());
	результат.Вставить("ОкончаниеРабочегоДня", Константы.ОкончаниеРабочегоДня.Получить());

	Возврат результат;
КонецФункции

&НаСервереБезКонтекста
Функция получитьТекущуюДатуНаСервере()
	Возврат ТекущаяДатаСеанса();
КонецФункции

&НаКлиенте
Процедура инициализация()
	_ВариантыИзмененияПериода = Новый Структура;
	_ВариантыИзмененияПериода.Вставить("Вперед", "Вперед");
	_ВариантыИзмененияПериода.Вставить("Назад", "Назад");
	_ВариантыИзмененияПериода.Вставить("Сегодня", "Сегодня");

	_ВариантыПериодов = Новый Структура;
	_ВариантыПериодов.Вставить("День", "День");
	_ВариантыПериодов.Вставить("Неделя", "Неделя");
	_ВариантыПериодов.Вставить("Месяц", "Месяц");

	ЭтотОбъект.ВариантПериода = ?(ЗначениеЗаполнено(ЭтотОбъект.ВариантПериода), ЭтотОбъект.ВариантПериода, _ВариантыПериодов.День);
КонецПроцедуры

&НаСервере
Процедура установитьНастройкиОтображениеПланировщикаНаСервере()
	периодРабочегоДня = получитьПериодРабочегоДняНаСервере();

	ЭтотОбъект.НачалоРабочегоДня = периодРабочегоДня.НачалоРабочегоДня;
	ЭтотОбъект.ОкончаниеРабочегоДня = периодРабочегоДня.ОкончаниеРабочегоДня;

	ЭтотОбъект.Планировщик.ОтображатьТекущуюДату = Истина;
	ЭтотОбъект.Планировщик.ОтступСНачалаПереносаШкалыВремени = ЭтотОбъект.НачалоРабочегоДня;
	ЭтотОбъект.Планировщик.ОтступСКонцаПереносаШкалыВремени = ?(ЭтотОбъект.ОкончаниеРабочегоДня = 0, 0, 24 - ЭтотОбъект.ОкончаниеРабочегоДня);
	ЭтотОбъект.Планировщик.ЕдиницаПериодическогоВарианта = ТипЕдиницыШкалыВремени.Час;
	ЭтотОбъект.Планировщик.КратностьПериодическогоВарианта = 24;
	ЭтотОбъект.Планировщик.ВыравниватьГраницыЭлементовПоШкалеВремени = Ложь;
	ЭтотОбъект.Планировщик.ФорматПеренесенныхЗаголовковШкалыВремени = "ДФ='дддд, д ММММ гггг'";
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции

﻿#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(_)
    заполнитьПериодОбработки();
    заполнитьДанные();
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(_)
    заполнитьДанные();
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура МесяцСтрокойНажатие(_, стандартнаяОбработка)
    стандартнаяОбработка = Ложь;
    выбратьПериодОбработки(Истина);
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийЭлементовШапкиФормы

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура заполнитьДанные()
    датаНачала = ЭтотОбъект.ПериодОбработки;
    датаОкончания = КонецМесяца(ЭтотОбъект.ПериодОбработки);

    заполнитьЧисловыеПоказатели(датаНачала, датаОкончания);

    заполнитьДиаграммуВыручки();
    заполнитьКруговыеДиаграммы();
КонецПроцедуры

&НаКлиенте
Асинх Функция выбратьПериодОбработки(Знач обновитьДанные = Ложь)
    подсказка = "Введите период получения данных";
    частьДаты = ЧастиДаты.Дата;
    результатДата = Ждать ВвестиДатуАсинх(ЭтотОбъект.ПериодОбработки, подсказка, частьДаты);
    Если результатДата <> Неопределено Тогда
        ЭтотОбъект.ПериодОбработки = НачалоМесяца(результатДата);
        ЭтотОбъект.МесяцСтрокой = Формат(ЭтотОбъект.ПериодОбработки, получитьФорматПериода());
        заполнитьДанные();
        Возврат Истина;
    КонецЕсли;

    Возврат Ложь;
КонецФункции

&НаКлиенте
Процедура заполнитьПериодОбработки()
    ЭтотОбъект.ПериодОбработки = НачалоМесяца(получитьТекущуюДатуНаСервере());
    ЭтотОбъект.МесяцСтрокой = Формат(ЭтотОбъект.ПериодОбработки, получитьФорматПериода());
КонецПроцедуры

&НаКлиенте
Процедура очиститьЗначенияЧисловыхПоказателей()
    ЭтотОбъект.ВыручкаЧисло = 0;
    ЭтотОбъект.СреднийЧек = 0;
    ЭтотОбъект.ВсегоЗаписей = 0;
    ЭтотОбъект.Завершенных = 0;
    ЭтотОбъект.ЗавершенныхПроцентСтрока = "";
КонецПроцедуры

&НаКлиенте
Процедура заполнитьЧисловыеПоказатели(Знач датаНачала = Неопределено, Знач датаОкончания = Неопределено)
    датаНачала = ?(датаНачала = Неопределено, ЭтотОбъект.ПериодОбработки, датаНачала);
    датаОкончания = ?(датаОкончания = Неопределено, КонецМесяца(датаНачала), датаОкончания);

    данныеПоказателей = получитьДанныеЧисловыхПоказателейНаСервере(датаНачала, датаОкончания);
    Если данныеПоказателей = Неопределено Тогда
        очиститьЗначенияЧисловыхПоказателей();
        Возврат;
    КонецЕсли;

    ЭтотОбъект.ВыручкаЧисло = данныеПоказателей.Выручка;
    ЭтотОбъект.СреднийЧек = ?(данныеПоказателей.Завершенных > 0,
            ОКР(данныеПоказателей.Выручка / данныеПоказателей.Завершенных, 2), 0);
    ЭтотОбъект.ВсегоЗаписей = данныеПоказателей.ВсегоЗаписей;
    ЭтотОбъект.Завершенных = данныеПоказателей.Завершенных;

    Если ЭтотОбъект.ВсегоЗаписей > 0 Тогда
        процентЗавершенных = ОКР((100 * ЭтотОбъект.Завершенных / ЭтотОбъект.ВсегоЗаписей), 2);
        ЭтотОбъект.ЗавершенныхПроцентСтрока = СтрШаблон("Это %1 процентов от всех записей", процентЗавершенных);
    Иначе
        ЗавершенныхПроцентСтрока = "В этом периоде нет записей клиентов!";
    КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура заполнитьДиаграммуВыручки()
    датаНачала = ЭтотОбъект.ПериодОбработки;
    датаОкончания = КонецМесяца(ЭтотОбъект.ПериодОбработки);

    продажиПоДням = получитьДанныеПродажПоДнямНаСервере(датаНачала, датаОкончания);

    ЭтотОбъект.ДиаграммаВыручка.Обновление = Ложь;
    ЭтотОбъект.ДиаграммаВыручка.Очистить();

    Если продажиПоДням <> Неопределено Тогда
        серияДанныхОборот = ДиаграммаВыручка.Серии.Добавить("Оборот");
        серияДанныхОборот.Цвет = WebЦвета.ЛососьСветлый;

        Для Каждого элемент Из продажиПоДням Цикл
            период_ = элемент.Период;
            сумма_ = элемент.Сумма;

            точкаДиаграммы = ЭтотОбъект.ДиаграммаВыручка.Точки.Добавить(период_);
            точкаДиаграммы.Текст = Формат(период_, "ДФ=dd.MM.yy");
            точкаДиаграммы.Расшифровка = период_;
            подсказка = СтрШаблон("Выручка %1 на %2", сумма_, Формат(период_, получитьФорматПериода()));
            ЭтотОбъект.ДиаграммаВыручка.УстановитьЗначение(
                точкаДиаграммы, серияДанныхОборот, сумма_, точкаДиаграммы.Расшифровка, подсказка);
        КонецЦикла;
    КонецЕсли;

    ЭтотОбъект.ДиаграммаВыручка.Обновление = Истина;
КонецПроцедуры

&НаКлиенте
Процедура заполнитьКруговыеДиаграммы()
    заполнитьДиаграммуПоИсточникамИнформации();
    заполнитьДиаграммуПоСотрудникам();
    заполнитьДиаграммуПоУслугам();
КонецПроцедуры

&НаКлиенте
Процедура заполнитьКруговуюДиаграмму(Знач данныеДляЗаполнения, Знач диаграмма, Знач имяОсиЗначений)
    диаграмма.Обновление = Ложь;
    диаграмма.Очистить();

    Если данныеДляЗаполнения <> Неопределено Тогда
        точкаДиаграммы = диаграмма.Точки.Добавить(имяОсиЗначений);
        точкаДиаграммы.Текст = имяОсиЗначений;
        точкаДиаграммы.ПриоритетЦвета = Ложь;

        Для Каждого элемент Из данныеДляЗаполнения Цикл
            серияДанных = диаграмма.Серии.Добавить(элемент.Ключ);
            диаграмма.УстановитьЗначение(
                точкаДиаграммы, серияДанных, элемент.Значение, Строка(элемент.Значение));
        КонецЦикла;
    КонецЕсли;

    диаграмма.Обновление = Истина;
КонецПроцедуры

&НаКлиенте
Процедура заполнитьДиаграммуПоУслугам()
    датаНачала = ЭтотОбъект.ПериодОбработки;
    датаОкончания = КонецМесяца(ЭтотОбъект.ПериодОбработки);

    продажиУслуг = получитьДолиПродажУслугНаСервере(датаНачала, датаОкончания, 0.1);
    заполнитьКруговуюДиаграмму(продажиУслуг,
        ЭтотОбъект.ДиаграммаПоУслугам, "Сумма");
КонецПроцедуры

&НаКлиенте
Процедура заполнитьДиаграммуПоИсточникамИнформации()
    датаНачала = ЭтотОбъект.ПериодОбработки;
    датаОкончания = КонецМесяца(ЭтотОбъект.ПериодОбработки);

    источникИнформацииПокупок = получитьИсточникиИнформацииПокупок(датаНачала, датаОкончания);
    заполнитьКруговуюДиаграмму(источникИнформацииПокупок,
        ЭтотОбъект.ДиаграммаПоРекламнымИсточникам, "Количество");
КонецПроцедуры

&НаКлиенте
Процедура заполнитьДиаграммуПоСотрудникам()
    датаНачала = ЭтотОбъект.ПериодОбработки;
    датаОкончания = КонецМесяца(ЭтотОбъект.ПериодОбработки);

    продажиСотрудников = получитьПродажиПоСотрудникамНаСервере(датаНачала, датаОкончания);
    заполнитьКруговуюДиаграмму(продажиСотрудников,
        ЭтотОбъект.ДиаграммаВыручкаПоСотрудникам, "Сумма");
КонецПроцедуры

#Область ЗапросыДанных
&НаСервереБезКонтекста
Функция получитьДанныеЧисловыхПоказателейНаСервере(Знач датаНачала, Знач датаОкончания)
    запрос = Новый Запрос;
    запрос.УстановитьПараметр("ДатаНачала", датаНачала);
    запрос.УстановитьПараметр("ДатаОкончания", датаОкончания);

    запрос.Текст =
        "ВЫБРАТЬ
        |	ЗаказыКлиентов.Регистратор КАК ЗаписьКлиента
        |ПОМЕСТИТЬ ВТ_ЗаказыКлиентов
        |ИЗ
        |	РегистрНакопления.ЗаказыКлиентов КАК ЗаказыКлиентов
        |ГДЕ
        |	ЗаказыКлиентов.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
        |	И ЗаказыКлиентов.Регистратор ССЫЛКА Документ.ЗаписьКлиента
        |
        |СГРУППИРОВАТЬ ПО
        |	ЗаказыКлиентов.Регистратор
        |
        |ИНДЕКСИРОВАТЬ ПО
        |	ЗаписьКлиента
        |;
        |
        |////////////////////////////////////////////////////////////////////////////////
        |ВЫБРАТЬ
        |	ПродажиОбороты.Регистратор КАК Регистратор,
        |	СУММА(ПродажиОбороты.СуммаОборот) КАК СуммаОборот
        |ПОМЕСТИТЬ ВТ_Продажи
        |ИЗ
        |	РегистрНакопления.Продажи.Обороты(&ДатаНачала, &ДатаОкончания, Регистратор, ) КАК ПродажиОбороты
        |
        |СГРУППИРОВАТЬ ПО
        |	ПродажиОбороты.Регистратор
        |
        |ИНДЕКСИРОВАТЬ ПО
        |	Регистратор
        |;
        |
        |////////////////////////////////////////////////////////////////////////////////
        |ВЫБРАТЬ ПЕРВЫЕ 1
        |	КОЛИЧЕСТВО(ВТ_ЗаказыКлиентов.ЗаписьКлиента) КАК ВсегоЗаписей,
        |	КОЛИЧЕСТВО(ВТ_Продажи.Регистратор) КАК Завершенных,
        |	СУММА(ВТ_Продажи.СуммаОборот) КАК Выручка
        |ИЗ
        |	ВТ_Продажи КАК ВТ_Продажи
        |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровИУслуг КАК РеализацияТоваровИУслуг
        |		ПО (РеализацияТоваровИУслуг.Ссылка = ВТ_Продажи.Регистратор)
        |		ПРАВОЕ СОЕДИНЕНИЕ ВТ_ЗаказыКлиентов КАК ВТ_ЗаказыКлиентов
        |		ПО (ВТ_ЗаказыКлиентов.ЗаписьКлиента = РеализацияТоваровИУслуг.ДокументОснование)
        |";

    результатЗапроса = запрос.Выполнить();
    Если результатЗапроса.Пустой() Тогда
        Возврат Неопределено;
    КонецЕсли;

    выборка = результатЗапроса.Выбрать();
    выборка.Следующий();
    результат = Новый Структура("Выручка, ВсегоЗаписей, Завершенных");
    ЗаполнитьЗначенияСвойств(результат, выборка);

    Возврат Новый ФиксированнаяСтруктура(результат);
КонецФункции

// Параметры:
//  датаНачала - Дата
//  датаОкончания - Дата
//
// Возвращаемое значение:
//  - Массив - Массив вида: [{ Период: Дата, Сумма: Число }]
&НаСервереБезКонтекста
Функция получитьДанныеПродажПоДнямНаСервере(Знач датаНачала, Знач датаОкончания)
    запрос = Новый Запрос;
    запрос.УстановитьПараметр("ДатаНачала", датаНачала);
    запрос.УстановитьПараметр("ДатаОкончания", КонецМесяца(датаОкончания));

    запрос.Текст =
        "ВЫБРАТЬ
        |	НачалоПериода(Продажи.Период, День) КАК Период,
        |	Продажи.СуммаОборот КАК СуммаОборот
        |ИЗ
        |	РегистрНакопления.Продажи.Обороты(&ДатаНачала, &ДатаОкончания, День, ) КАК Продажи
        |
        |УПОРЯДОЧИТЬ ПО
        |   Период
        |";

    результатЗапроса = запрос.Выполнить();
    Если результатЗапроса.Пустой() Тогда
        Возврат Неопределено;
    КонецЕсли;

    результат = Новый Массив;
    выборка = результатЗапроса.Выбрать();
    Пока выборка.Следующий() Цикл
        результат.Добавить(Новый ФиксированнаяСтруктура("Период, Сумма", выборка.Период, выборка.СуммаОборот));
    КонецЦикла;

    Возврат результат;
КонецФункции

&НаСервереБезКонтекста
Функция получитьДолиПродажУслугНаСервере(Знач датаНачала, Знач датаОкончания, Знач доляПродаж)
    запрос = Новый Запрос;
    запрос.УстановитьПараметр("ДатаНачала", датаНачала);
    запрос.УстановитьПараметр("ДатаОкончания", датаОкончания);
    запрос.УстановитьПараметр("ДоляПродаж", доляПродаж);

    запрос.Текст =
        "ВЫБРАТЬ
        |	ПродажиОбороты.Номенклатура КАК Номенклатура,
        |	СУММА(ПродажиОбороты.СуммаОборот) КАК СуммаОборот
        |ПОМЕСТИТЬ ВТ_ПродажиУслуг
        |ИЗ
        |	РегистрНакопления.Продажи.Обороты(&ДатаНачала, &ДатаОкончания, Регистратор,
        |		Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга)) КАК ПродажиОбороты
        |ГДЕ
        |	ПродажиОбороты.СуммаОборот <> 0
        |
        |СГРУППИРОВАТЬ ПО
        |	ПродажиОбороты.Номенклатура
        |;
        |
        |////////////////////////////////////////////////////////////////////////////////
        |ВЫБРАТЬ ПЕРВЫЕ 1
        |	СУММА(ВТ_ПродажиУслуг.СуммаОборот) КАК СуммаОборот
        |ПОМЕСТИТЬ ВТ_ОбщаяСуммаПродажУслуг
        |ИЗ
        |	ВТ_ПродажиУслуг КАК ВТ_ПродажиУслуг
        |;
        |
        |////////////////////////////////////////////////////////////////////////////////
        |ВЫБРАТЬ
        |	ВЫБОР
        |		КОГДА ВТ_ПродажиУслуг.СуммаОборот / ВТ_ОбщаяСуммаПродажУслуг.СуммаОборот > &ДоляПродаж
        |			ТОГДА ВТ_ПродажиУслуг.Номенклатура.Представление
        |		ИНАЧЕ ""Прочее""
        |	КОНЕЦ КАК Номенклатура,
        |	ВТ_ПродажиУслуг.СуммаОборот КАК СуммаПродаж
        |ПОМЕСТИТЬ ВТ_ПродажиУслугПоКатегориям
        |ИЗ
        |	ВТ_ПродажиУслуг КАК ВТ_ПродажиУслуг
        |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ОбщаяСуммаПродажУслуг КАК ВТ_ОбщаяСуммаПродажУслуг
        |		ПО (ИСТИНА)
        |;
        |
        |////////////////////////////////////////////////////////////////////////////////
        |ВЫБРАТЬ
        |	ВТ_ПродажиУслугПоКатегориям.Номенклатура КАК Номенклатура,
        |	СУММА(ВТ_ПродажиУслугПоКатегориям.СуммаПродаж) КАК СуммаПродаж
        |ИЗ
        |	ВТ_ПродажиУслугПоКатегориям КАК ВТ_ПродажиУслугПоКатегориям
        |
        |СГРУППИРОВАТЬ ПО
        |	ВТ_ПродажиУслугПоКатегориям.Номенклатура
        |";

    результатЗапроса = запрос.Выполнить();
    Если результатЗапроса.Пустой() Тогда
        Возврат Неопределено;
    КонецЕсли;

    результат = Новый Соответствие;
    выборка = результатЗапроса.Выбрать();
    Пока выборка.Следующий() Цикл
        результат.Вставить(выборка.Номенклатура, выборка.СуммаПродаж);
    КонецЦикла;

    Возврат Новый ФиксированноеСоответствие(результат);
КонецФункции

&НаСервереБезКонтекста
Функция получитьИсточникиИнформацииПокупок(Знач датаНачала, Знач датаОкончания, Знач представлениеNull = "Не указан")
    запрос = Новый Запрос;
    запрос.УстановитьПараметр("ДатаНачала", датаНачала);
    запрос.УстановитьПараметр("ДатаОкончания", датаОкончания);
    запрос.УстановитьПараметр("ПредставлениеNull", представлениеNull);

    запрос.Текст =
        "ВЫБРАТЬ
        |	ЕСТЬNULL(Продажи.Клиент.Источник.Представление, &ПредставлениеNull) КАК ИсточникИнформации,
        |	СУММА(Продажи.КоличествоОборот) КАК Количество
        |ИЗ
        |	РегистрНакопления.Продажи.Обороты(&ДатаНачала, &ДатаОкончания, Регистратор, ) КАК Продажи
        |ГДЕ
        |	Продажи.КоличествоОборот <> 0
        |
        |СГРУППИРОВАТЬ ПО
        |	ЕСТЬNULL(Продажи.Клиент.Источник.Представление, &ПредставлениеNull)
        |";

    результатЗапроса = запрос.Выполнить();
    Если результатЗапроса.Пустой() Тогда
        Возврат Неопределено;
    КонецЕсли;

    результат = Новый Соответствие;
    выборка = результатЗапроса.Выбрать();
    Пока выборка.Следующий() Цикл
        результат.Вставить(выборка.ИсточникИнформации, выборка.Количество);
    КонецЦикла;

    Возврат Новый ФиксированноеСоответствие(результат);
КонецФункции

&НаСервереБезКонтекста
Функция получитьПродажиПоСотрудникамНаСервере(Знач датаНачала, Знач датаОкончания)
    запрос = Новый Запрос;
    запрос.УстановитьПараметр("ДатаНачала", датаНачала);
    запрос.УстановитьПараметр("ДатаОкончания", датаОкончания);

    запрос.Текст =
        "ВЫБРАТЬ
        |	СУММА(Продажи.СуммаОборот) КАК Сумма,
        |	Продажи.Сотрудник.Представление КАК Сотрудник
        |ИЗ
        |	РегистрНакопления.Продажи.Обороты(&ДатаНачала, &ДатаОкончания, Регистратор, ) КАК Продажи
        |ГДЕ
        |	Продажи.КоличествоОборот <> 0
        |
        |СГРУППИРОВАТЬ ПО
        |	Продажи.Сотрудник.Представление
        |";

    результатЗапроса = запрос.Выполнить();
    Если результатЗапроса.Пустой() Тогда
        Возврат Неопределено;
    КонецЕсли;

    результат = Новый Соответствие;
    выборка = результатЗапроса.Выбрать();
    Пока выборка.Следующий() Цикл
        результат.Вставить(выборка.Сотрудник, выборка.Сумма);
    КонецЦикла;

    Возврат Новый ФиксированноеСоответствие(результат);
КонецФункции
#КонецОбласти // ЗапросыДанных

&НаСервереБезКонтекста
Функция получитьТекущуюДатуНаСервере()
    Возврат ТекущаяДатаСеанса();
КонецФункции

&НаКлиенте
Функция получитьФорматПериода()
    Возврат "ДФ='ММММ гггг'";
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции

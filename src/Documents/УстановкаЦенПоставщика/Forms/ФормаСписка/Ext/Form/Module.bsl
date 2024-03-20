﻿#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
    ЭтотОбъект._Состояние = Новый Структура("АктивнаяФормаПрайсЛиста");
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(имяСобытия, параметрыСобытия, ___)
    Если имяСобытия <> "ЗаписьПрайсЛистаВДокумент" ИЛИ параметрыСобытия = Неопределено Тогда
        Возврат;
    КонецЕсли;

    создательФормы = Неопределено;
    загрузчик = Неопределено;

    параметрыСобытия.Свойство("СоздательФормы", создательФормы);
    Если создательФормы <> ЭтотОбъект.УникальныйИдентификатор Тогда
        Возврат;
    КонецЕсли;

    загрузчик = Неопределено;
    параметрыСобытия.Свойство("Объект", загрузчик);

    ДиагностикаКлиентСервер.Утверждение(загрузчик <> Неопределено);
    ДиагностикаКлиентСервер.Утверждение(загрузчик.ДатаПрайсЛиста <> Неопределено);
    ДиагностикаКлиентСервер.Утверждение(загрузчик.ПрайсЛист <> Неопределено);
    ДиагностикаКлиентСервер.Утверждение(загрузчик.Поставщик <> Неопределено);

    документУстановкиЦенСсылка = заполнитьДокументНаСервере(
            загрузчик.ДатаПрайсЛиста, загрузчик.Поставщик, загрузчик.ПрайсЛист);

    Если ЭтотОбъект._Состояние.АктивнаяФормаПрайсЛиста <> Неопределено Тогда
        ЭтотОбъект._Состояние.АктивнаяФормаПрайсЛиста.Закрыть();
        ЭтотОбъект._Состояние.АктивнаяФормаПрайсЛиста = Неопределено;
    КонецЕсли;

    //ОткрытьЗначение(документУстановкиЦенСсылка);
    //ОписаниеОповещенияОЗакрытии
    ОткрытьФорму(получитьПолноеИмяФормыДокументаНаСервере(документУстановкиЦенСсылка));

    //форма = документУстановкиЦен.ПолучитьФорму("ФормаДокумента");
    //форма.Открыть();
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьИзПрайсЛиста(_)
    форма = ФормыКонфигурацииКлиент.ОткрытьФормуЗагрузкиПрайсЛиста(ЭтотОбъект,
    Новый Структура("СоздательФормы", ЭтотОбъект.УникальныйИдентификатор));
    ЭтотОбъект._Состояние.АктивнаяФормаПрайсЛиста = форма;
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция заполнитьДокументНаСервере(Знач дата, Знач контрагент, Знач прайсЛист)
    документУстановкиЦен = Документы.УстановкаЦенПоставщика.СоздатьДокумент();

    документУстановкиЦен.Дата = дата;
    документУстановкиЦен.Контрагент = контрагент;
    Документы.УстановкаЦенПоставщика.ЗаполнитьТаблицуТоваров(документУстановкиЦен.Товары, прайсЛист);
    документУстановкиЦен.Записать();

    Возврат документУстановкиЦен.Ссылка;
КонецФункции

&НаСервереБезКонтекста
Функция получитьПолноеИмяФормыДокументаНаСервере(Знач документСсылка)
    метаданныеОбъекта = Метаданные.НайтиПоТипу(ТипЗнч(документСсылка));
    Если метаданныеОбъекта = Неопределено Тогда
        Возврат Неопределено;
    КонецЕсли;

    Возврат метаданныеОбъекта.Формы.ФормаДокумента.ПолноеИмя();
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции

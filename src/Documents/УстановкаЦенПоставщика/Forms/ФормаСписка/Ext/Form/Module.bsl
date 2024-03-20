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
    Если создательФормы = Неопределено ИЛИ создательФормы <> ЭтотОбъект Тогда
        Возврат;
    КонецЕсли;

    загрузчик = Неопределено;
    параметрыСобытия.Свойство("Объект", загрузчик);

    ДиагностикаКлиентСервер.Утверждение(загрузчик <> Неопределено);
    ДиагностикаКлиентСервер.Утверждение(загрузчик.ДатаПрайсЛиста <> Неопределено);
    ДиагностикаКлиентСервер.Утверждение(загрузчик.ПрайсЛист <> Неопределено);
    ДиагностикаКлиентСервер.Утверждение(загрузчик.Поставщик <> Неопределено);

    заполнитьДокументНаСервере(загрузчик.ДатаПрайсЛиста, загрузчик.Поставщик, загрузчик.ПрайсЛист);
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьИзПрайсЛиста(_)
    форма = ФормыКонфигурацииКлиент.ОткрытьФормуЗагрузкиПрайсЛиста(ЭтотОбъект, Новый Структура("СоздательФормы", ЭтотОбъект));
    ЭтотОбъект._Состояние.АктивнаяФормаПрайсЛиста = форма;
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура заполнитьДокументНаСервере(Знач дата, Знач контрагент, Знач прайсЛист)
    документУстановкиЦен = Документы.УстановкаЦенПоставщика.СоздатьДокумент();

    документУстановкиЦен.Дата = дата;
    документУстановкиЦен.Контрагент = контрагент;
    Документы.УстановкаЦенПоставщика.ЗаполнитьТаблицуТоваров(документУстановкиЦен.Товары, прайсЛист);
    //документУстановкиЦен.Записать();
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции

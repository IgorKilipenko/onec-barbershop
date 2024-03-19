﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(_, __)
    ЭтотОбъект._Состояние = Новый Структура;
    ЭтотОбъект._Состояние.Вставить("ИмяДокументаОснования");
    ЭтотОбъект._Состояние.Вставить("ПрайсЛистЗаполнен", Ложь);

    имяДокументаОснования = Неопределено;
    Параметры.Свойство("ИмяДокументаОснования", имяДокументаОснования);
    ЭтотОбъект._Состояние.ИмяДокументаОснования = имяДокументаОснования;

    Если ТипЗнч(имяДокументаОснования) = Тип("Строка") И ЗначениеЗаполнено(имяДокументаОснования) Тогда
        Параметры.Свойство("Дата", Объект.ДатаПрайсЛиста);
        Параметры.Свойство("Контрагент", Объект.Поставщик);

        Если Объект.ДатаПрайсЛиста <> Неопределено Тогда
            Элементы.ДатаПрайсЛиста.Доступность = Ложь;
        КонецЕсли;

        Если Объект.Поставщик <> Неопределено Тогда
            Элементы.Поставщик.Доступность = Ложь;
        КонецЕсли;
    КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(_)
    обновитьСостояниеФормы();
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

#Область ОбработчикиКомандФормы

&НаКлиенте
Асинх Процедура ЗагрузитьПрайсЛист(_)
    результат = Ждать вывестиТабличныйДокумент();
    ЭтотОбъект._Состояние.ПрайсЛистЗаполнен = результат;
    обновитьСостояниеФормы();
КонецПроцедуры

&НаКлиенте
Процедура ПоместитьВДокумент(_)
    имяСобытия = "ЗаписьПрайсЛистаВДокумент";
    параметрыОповещенияЗаписиПрайсЛиста = Новый Структура("Объект, ИмяДокументаОснования",
            ЭтотОбъект.Объект, _Состояние.ИмяДокументаОснования);
    Оповестить(имяСобытия, параметрыОповещенияЗаписиПрайсЛиста, ЭтотОбъект);
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Асинх Функция открытьТабличныйФайлДанных()
    параметрыВыбораФайла = Новый ПараметрыДиалогаПомещенияФайлов(
            "Выбор файла прайс-листа", Ложь, "Файл данных (*.xls, *.xlsx, *.ods)|*.xls;*.xlsx;*.ods");
    описаниеФайлаДанных = Ждать ПоместитьФайлНаСерверАсинх( , , , параметрыВыбораФайла, ЭтотОбъект.УникальныйИдентификатор);

    Если описаниеФайлаДанных = Неопределено Тогда
        Возврат Неопределено; // Файл не выбран
    КонецЕсли;

    ДиагностикаКлиентСервер.Утверждение(описаниеФайлаДанных.ПомещениеФайлаОтменено = Ложь
            И описаниеФайлаДанных.Адрес <> Неопределено,
            "Файл должен быть помещен в хранилище.");

    имяФайлаДанных = Ждать записатьВременныйФайлНаСервере(описаниеФайлаДанных.Адрес, описаниеФайлаДанных.СсылкаНаФайл.Расширение);

    Возврат Новый Структура("ИмяВременногоФайла, ОписаниеПомещенногоФайла", имяФайлаДанных, описаниеФайлаДанных);
КонецФункции

&НаКлиенте
Асинх Функция вывестиТабличныйДокумент()
    файлТабличныхДанных = Ждать открытьТабличныйФайлДанных();
    Если файлТабличныхДанных = Неопределено Тогда
        Возврат Ложь; // Файл не выбран
    КонецЕсли;

    Попытка
        вывестиТабличныйДокументНаСервере(
            файлТабличныхДанных.ИмяВременногоФайла,
            файлТабличныхДанных.ОписаниеПомещенногоФайла.СсылкаНаФайл.Имя);
    Исключение
        сообщение = Новый СообщениеПользователю;
        сообщение.Текст = СтрШаблон(
                "Ошибка чтения фала прайс-листа: ""%1"".
                |Описание ошибки: %2",
                файлТабличныхДанных.ОписаниеПомещенногоФайла.СсылкаНаФайл.Имя,
                ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
        сообщение.Сообщить();

        таблДок = Неопределено;
    КонецПопытки;

    Возврат Истина;
КонецФункции

&НаСервере
Функция вывестиТабличныйДокументНаСервере(Знач имяВременногоФайла, Знач имяИсходногоФайла)
    таблДок = Неопределено;

    Попытка
        таблДок = получитьТабличныйДокументИзФайлаНаСервере(имяВременногоФайла);

    Исключение
        сообщение = Новый СообщениеПользователю;
        сообщение.Текст = СтрШаблон(
                "Ошибка чтения фала прайс-листа: ""%1"".
                |Описание ошибки: %2",
                имяИсходногоФайла,
                ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
        сообщение.Сообщить();

        таблДок = Неопределено;
    КонецПопытки;

    удалитьВременныйФайлНаСервере(имяВременногоФайла);

    Если таблДок = Неопределено Тогда
        Возврат Ложь;
    КонецЕсли;

    Объект.ПрайсЛист.Вывести(таблДок);

    Возврат Истина;
КонецФункции

&НаСервереБезКонтекста
Функция получитьТабличныйДокументИзФайлаНаСервере(Знач имяФайлаДанных)
    результат = Новый ТабличныйДокумент;
    результат.Прочитать(имяФайлаДанных);

    Возврат результат;
КонецФункции

&НаСервереБезКонтекста
Функция записатьВременныйФайлНаСервере(Знач адрес, Знач расширение)
    // BSLLS:MissingTemporaryFileDeletion-off
    имяФайлаДанных = ПолучитьИмяВременногоФайла(расширение);
    потокДанных = ПолучитьИзВременногоХранилища(адрес);

    ДиагностикаКлиентСервер.Утверждение(ТипЗнч(потокДанных) = Тип("ДвоичныеДанные"),
            "Данные полученные из временного хранилища должны быть типа: ""ДвоичныеДанные""");

    потокДанных.Записать(имяФайлаДанных);

    Возврат имяФайлаДанных;
КонецФункции

&НаСервереБезКонтекста
Функция удалитьВременныйФайлНаСервере(Знач имяФайлаДанных)
    Попытка
        УдалитьФайлы(имяФайлаДанных);
    Исключение
        записьОбОшибкеВЖурналРегистрацииНаСервере("ПолучитьТабличныйДокументИзФайла",
            ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));

        Возврат Ложь;
    КонецПопытки;

    Возврат Истина;
КонецФункции

&НаСервереБезКонтекста
Процедура записьОбОшибкеВЖурналРегистрацииНаСервере(Знач имяСобытия, Знач комментарий)
    ЗаписьЖурналаРегистрации(СтрШаблон("ЗагрузкаПрайсЛиста.%1", имяСобытия), УровеньЖурналаРегистрации.Ошибка, , ,
        ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
КонецПроцедуры

&НаКлиенте
Процедура обновитьСостояниеФормы()
    Элементы.ПрайсЛист.Доступность = ЭтотОбъект._Состояние.ПрайсЛистЗаполнен;
    Элементы.ПоместитьВДокумент.Видимость = ЭтотОбъект._Состояние.ПрайсЛистЗаполнен;
    Элементы.ПоместитьВДокумент.Доступность = ЭтотОбъект._Состояние.ПрайсЛистЗаполнен;
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции

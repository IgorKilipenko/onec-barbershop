﻿#Область ПрограммныйИнтерфейс

// Параметры:
//  табДокПрайсЛиста - ТабличныйДокумент
//  вызыватьИсключение - Булево - По умолчанию: Ложь, если Истина, в случае ошибки анализа будет вызвано исключение
//  оповещатьОбОшибках - Булево - По умолчанию: Истина
// Возвращаемое значение:
//  ТаблицаЗначений
Функция ПолучитьТаблицуЗначенийИзТабличногоДокумента(
        Знач табДокПрайсЛиста, Знач вызыватьИсключение = Ложь, оповещатьОбОшибках = Истина) Экспорт

    результат = Новый ТаблицаЗначений;
    результат.Колонки.Добавить("АртикулНоменклатуры", Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(13)));
    результат.Колонки.Добавить("Цена", Новый ОписаниеТипов("Число"));

    ошибкиАнализаДанных = Новый Массив;
    данныеПрайсЛиста = получитьДанныеПрайсЛиста(табДокПрайсЛиста);

    Если НЕ данныеПрайсЛиста.Успех Тогда
        текстСообщения = ?(данныеПрайсЛиста.СообщениеОбОшибке <> Неопределено,
                данныеПрайсЛиста.СообщениеОбОшибке, "Ошибка анализа структуры табличного документа.");
        ошибкиАнализаДанных.Добавить(текстСообщения);

        сообщитьОбОшибках(ошибкиАнализаДанных, вызыватьИсключение, оповещатьОбОшибках);
        Возврат результат;
    КонецЕсли;

    перваяСтрока = данныеПрайсЛиста.ОбластьДанных.Верх;
    последняяСтрока = данныеПрайсЛиста.ОбластьДанных.Низ;

    ДиагностикаКлиентСервер.Утверждение(данныеПрайсЛиста.СтруктураЗаголовков.Заголовки.Артикул.АдресЯчейки <> Неопределено
        И данныеПрайсЛиста.СтруктураЗаголовков.Заголовки.Цена.АдресЯчейки <> Неопределено);

    номерСтолбцаАртикул = данныеПрайсЛиста.СтруктураЗаголовков.Заголовки.Артикул.АдресЯчейки.Столбец;
    номерСтолбцаЦена = данныеПрайсЛиста.СтруктураЗаголовков.Заголовки.Цена.АдресЯчейки.Столбец;

    Если перваяСтрока = последняяСтрока Тогда
        ошибкиАнализаДанных.Вставить("Прайс-лист не содержит данных.");
    КонецЕсли;

    Для номерСтроки = перваяСтрока По последняяСтрока Цикл
        естьОшибкиАнализаСтроки = Ложь;

        артикулНоменклатуры = Строка(табДокПрайсЛиста.Область(номерСтроки, номерСтолбцаАртикул).Текст);
        ценаНоменклатуры = ПреобразованиеТиповКлиентСервер.ПривестиСтрокуКЧислу(
                табДокПрайсЛиста.Область(номерСтроки, номерСтолбцаЦена).Текст, Истина);

        Если ценаНоменклатуры = Неопределено Тогда
            естьОшибкиАнализаСтроки = Истина;
            ошибкиАнализаДанных.Добавить(СтрШаблон("Ошибка анализа значения цены в строке %1", Формат(номерСтроки, "ЧГ=0")));
        КонецЕсли;

        Если ПустаяСтрока(артикулНоменклатуры) Тогда
            естьОшибкиАнализаСтроки = Истина;
            ошибкиАнализаДанных.Добавить(СтрШаблон("Ошибка анализа значения артикула в строке %1", Формат(номерСтроки, "ЧГ=0")));
        КонецЕсли;

        Если естьОшибкиАнализаСтроки Тогда
            Если вызыватьИсключение Тогда
                Прервать;
            Иначе
                Продолжить;
            КонецЕсли;
        КонецЕсли;

        новаяСтрокаПрайса = результат.Добавить();
        новаяСтрокаПрайса.АртикулНоменклатуры = артикулНоменклатуры;
        новаяСтрокаПрайса.Цена = ценаНоменклатуры;
    КонецЦикла;

    Если ошибкиАнализаДанных.Количество() > 0 Тогда
        сообщитьОбОшибках(ошибкиАнализаДанных, вызыватьИсключение, оповещатьОбОшибках);
    КонецЕсли;

    Возврат результат;
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

// Параметры:
//  табДокПрайсЛиста - ТабличныйДокумент
// Возвращаемое значение:
//  - Структура
//      * Успех - Булево - Результат выполнения
//      * СообщениеОбОшибке - Строка, Неопределено
//      * ОбластьЗаголовков - ОбластьЯчеекТабличногоДокумента, Неопределено
//      * ОбластьДанных - ОбластьЯчеекТабличногоДокумента, Неопределено
//      * СтруктураЗаголовков - Структура
//          ** АдресЯчейки - Неопределено, Структура
//              *** Строка - Число
//              *** Столбец - Число
//          ** ШаблонПоиска - Строка
Функция получитьДанныеПрайсЛиста(Знач табДокПрайсЛиста)
    результат = Новый Структура;
    результат.Вставить("ОбластьЗаголовков", Неопределено);
    результат.Вставить("ОбластьДанных", Неопределено);
    результат.Вставить("СтруктураЗаголовков", Неопределено);
    результат.Вставить("Успех", Ложь);
    результат.Вставить("СообщениеОбОшибке", Неопределено);

    структураОбластиЗаголовков = найтиПозициюСтолбцовПрайсЛиста(табДокПрайсЛиста);
    результат.СтруктураЗаголовков = структураОбластиЗаголовков;

    Если структураОбластиЗаголовков.Заголовки.Количество() = 0 Тогда
        результат.СообщениеОбОшибке =
            "Ошибка анализа структуры табличного документа. Не найдена область заголовков прайс-листа.
            |Таблица прайс-листа должна содержать заголовки столбцов: [Артикул, Цена]";
        Возврат результат;
    КонецЕсли;

    перваяСтрока = структураОбластиЗаголовков.ДиапазонОбластиЗаголовков.ПерваяСтрока + 1;
    первыйСтолбец = структураОбластиЗаголовков.ДиапазонОбластиЗаголовков.ПервыйСтолбец + 1;
    последнийСтолбец = структураОбластиЗаголовков.ДиапазонОбластиЗаголовков.ПоследнийСтолбец;
    последняяСтрока = перваяСтрока;

    // Поиск последней строки данных таблицы прайс листа
    Для номерСтроки = перваяСтрока По табДокПрайсЛиста.ВысотаТаблицы Цикл
        этоПустаяСтрока = Истина;
        Для номерСтолбца = первыйСтолбец По последнийСтолбец Цикл
            текстЯчейки = табДокПрайсЛиста.Область(номерСтроки, номерСтолбца).Текст;
            этоПустаяСтрока = этоПустаяСтрока
                И РаботаСоСтрокамиВызовСервера.ПодобнаПоРегулярномуВыражению(текстЯчейки, "\s*");
        КонецЦикла;

        Если этоПустаяСтрока Тогда
            Прервать;
        КонецЕсли;

        последняяСтрока = номерСтроки;
    КонецЦикла;

    результат.Успех = Истина;
    результат.ОбластьЗаголовков = табДокПрайсЛиста.Область(
            структураОбластиЗаголовков.ДиапазонОбластиЗаголовков.ПерваяСтрока,
            структураОбластиЗаголовков.ДиапазонОбластиЗаголовков.ПервыйСтолбец,
            структураОбластиЗаголовков.ДиапазонОбластиЗаголовков.ПоследняяСтрока,
            структураОбластиЗаголовков.ДиапазонОбластиЗаголовков.ПоследнийСтолбец);

    результат.ОбластьДанных = табДокПрайсЛиста.Область(
            перваяСтрока,
            первыйСтолбец,
            последняяСтрока,
            последнийСтолбец);

    Возврат результат;
КонецФункции

// Параметры:
//  табДокПрайсЛиста - ТабличныйДокумент
// Возвращаемое значение:
//  - Структура
//      * Заголовки - Структура
//          ** АдресЯчейки - Неопределено, Структура
//              *** Строка - Число
//              *** Столбец - Число
//          ** ШаблонПоиска - Строка
//      * ДиапазонОбластиЗаголовков - Структура
//          ** ПерваяСтрока - Число
//          ** ПоследняяСтрока - Число
//          ** ПервыйСтолбец - Число
//          ** ПоследнийСтолбец - Число
Функция найтиПозициюСтолбцовПрайсЛиста(Знач табДокПрайсЛиста)
    искомыеСтолбцы = Новый Структура;
    искомыеСтолбцы_Ключи = "ШаблонПоиска, ИсходныйТекст, АдресЯчейки";
    искомыеСтолбцы.Вставить("Артикул", Новый Структура(искомыеСтолбцы_Ключи, ".*[Аа]ртикул.*", ""));
    искомыеСтолбцы.Вставить("Цена", Новый Структура(искомыеСтолбцы_Ключи, ".*[Цц]ен[аы].*", ""));

    найденныеСтолбцы = Новый Структура;
    диапазонОбластиЗаголовков = Новый Структура;
    диапазонОбластиЗаголовков.Вставить("ПерваяСтрока", 1);
    диапазонОбластиЗаголовков.Вставить("ПоследняяСтрока", 1);
    диапазонОбластиЗаголовков.Вставить("ПервыйСтолбец", 1);
    диапазонОбластиЗаголовков.Вставить("ПоследнийСтолбец", 1);

    результат = Новый Структура("Заголовки, ДиапазонОбластиЗаголовков", найденныеСтолбцы, диапазонОбластиЗаголовков);

    Для номерСтроки = 1 По табДокПрайсЛиста.ВысотаТаблицы Цикл // Для каждой строки
        Для номерСтолбца = 1 По табДокПрайсЛиста.ШиринаТаблицы Цикл // Для каждого столбца

            // Поиск искомых столбцов в текущей ячейке
            текстЯчейки = табДокПрайсЛиста.Область(номерСтроки, номерСтолбца).Текст;
            Для Каждого искомыйСтолбецКЗ Из искомыеСтолбцы Цикл
                искомыйСтолбец = искомыйСтолбецКЗ.Значение;

                Если искомыйСтолбец.АдресЯчейки <> Неопределено Тогда // Столбец найден ранее
                    Продолжить; // Переход к обработке следующего искомого столбца для текущей ячейки
                КонецЕсли;

                этоИскомыйСтолбец = РаботаСоСтрокамиВызовСервера.ПодобнаПоРегулярномуВыражению(
                        текстЯчейки, искомыйСтолбец.ШаблонПоиска);
                Если этоИскомыйСтолбец Тогда
                    искомыйСтолбец.АдресЯчейки = Новый Структура("Строка, Столбец", номерСтроки, номерСтолбца);
                    искомыйСтолбец.ИсходныйТекст = текстЯчейки;
                    найденныеСтолбцы.Вставить(искомыйСтолбецКЗ.Ключ, искомыйСтолбец);
                    Прервать; // Переход к обработке следующей ячейки строки
                КонецЕсли;
            КонецЦикла;
        КонецЦикла;

        диапазонОбластиЗаголовков.ПоследняяСтрока = номерСтроки;
        Если найденныеСтолбцы.Количество() = искомыеСтолбцы.Количество() Тогда
            Прервать; // Завершение цикла обхода строк - т.к. все значения найдены
        КонецЕсли;
    КонецЦикла;

    // Заполнение значений диапазона области заголовков
    Для Каждого столбецКЗ Из найденныеСтолбцы Цикл
        адресЯчейки = столбецКЗ.Значение.АдресЯчейки;

        диапазонОбластиЗаголовков.ПерваяСтрока =
            Макс(диапазонОбластиЗаголовков.ПерваяСтрока, адресЯчейки.Строка);

        диапазонОбластиЗаголовков.ПервыйСтолбец =
            Мин(диапазонОбластиЗаголовков.ПервыйСтолбец, адресЯчейки.Столбец);

        диапазонОбластиЗаголовков.ПоследнийСтолбец =
            Макс(диапазонОбластиЗаголовков.ПоследнийСтолбец, адресЯчейки.Столбец);
    КонецЦикла;

    Возврат результат;
КонецФункции

Процедура сообщитьОбОшибках(Знач ошибки, вызыватьИсключение = Ложь, оповещатьОбОшибках = Истина)
    Если ошибки.Количество() = 0 Тогда
        Если вызыватьИсключение Тогда
            ВызватьИсключение ошибки[0];
        ИначеЕсли оповещатьОбОшибках Тогда
            Для Каждого текстСообщения Из ошибки Цикл
                сообщение = Новый СообщениеПользователю;
                сообщение.Текст = текстСообщения;
                сообщение.Сообщить();
            КонецЦикла;
        КонецЕсли;
    КонецЕсли;
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции

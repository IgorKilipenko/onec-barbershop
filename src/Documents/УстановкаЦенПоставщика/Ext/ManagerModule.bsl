﻿#Область ПрограммныйИнтерфейс

// Параметры:
//  товары - ТабличнаяЧасть - Таблица (приемник) документа в которую будет выполнена запись данных из прайс-листа
//  прайсЛист - ТабличныйДокумент - Прайс-лист (источник) - табличный документ
//      данные из которого будут помещены в Таблица приемника
// Возвращаемое значение:
//  - Число - Количество записанных строк данных из прайс-листа
Функция ЗаполнитьТаблицуТоваров(Знач товары, Знач прайсЛист) Экспорт
    прайсДист = Неопределено;
    Попытка
        прайсДист = Обработки.ЗагрузкаПрайсЛиста.ПолучитьТаблицуЗначенийИзТабличногоДокумента(прайсЛист);
    Исключение
        Сообщение = Новый СообщениеПользователю;
        Сообщение.Текст = СтрШаблон(
                "Ошибка чтения данных из прайс-листа.
                |Описание ошибки: %1", ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
        Сообщение.Сообщить();

        Возврат 0;
    КонецПопытки;

    запрос = Новый Запрос;
    запрос.Текст =
        "ВЫБРАТЬ
        |    ТаблицаПрайсЛиста.АртикулНоменклатуры КАК Артикул,
        |    ТаблицаПрайсЛиста.Цена КАК Цена
        |ПОМЕСТИТЬ ВТ_ТаблицаПрайсЛиста
        |ИЗ
        |    &ТаблицаПрайсЛиста КАК ТаблицаПрайсЛиста
        |;
        |
        |////////////////////////////////////////////////////////////////////////////////
        |ВЫБРАТЬ
        |    Ном.Ссылка КАК Номенклатура,
        |    ВТ_ТаблицаПрайсЛиста.Цена КАК Цена
        |ИЗ
        |    ВТ_ТаблицаПрайсЛиста КАК ВТ_ТаблицаПрайсЛиста
        |        ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Ном
        |        ПО ВТ_ТаблицаПрайсЛиста.Артикул = Ном.Артикул
        |";

    запрос.УстановитьПараметр("ТаблицаПрайсЛиста", прайсДист);
    результатВыполненияЗапроса = запрос.Выполнить();
    выборка = результатВыполненияЗапроса.Выбрать();

    количествоЗаписанныхСтрок = 0;
    Пока выборка.Следующий() Цикл
        новСтрокаТовары = товары.Добавить();
        новСтрокаТовары.Номенклатура = выборка.Номенклатура;
        новСтрокаТовары.Цена = выборка.Цена;

        количествоЗаписанныхСтрок = количествоЗаписанныхСтрок + 1;
    КонецЦикла;

    Возврат количествоЗаписанныхСтрок;
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

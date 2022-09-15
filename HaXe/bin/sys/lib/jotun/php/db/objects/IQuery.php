<?php
/**
 */

namespace jotun\php\db\objects;

use \php\Boot;

/**
 * @author Rafael Moreira
 */
interface IQuery {
}

Boot::registerClass(IQuery::class, 'jotun.php.db.objects.IQuery');

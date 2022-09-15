<?php
/**
 */

namespace jotun\net;

use \php\Boot;
use \jotun\objects\IResolve;

/**
 * @author Rafael Moreira
 */
interface IDomainData extends IResolve {
}

Boot::registerClass(IDomainData::class, 'jotun.net.IDomainData');

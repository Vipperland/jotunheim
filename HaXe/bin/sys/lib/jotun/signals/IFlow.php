<?php
/**
 */

namespace jotun\signals;

use \php\Boot;

/**
 * @author Rafael Moreira <rafael@gateofsirius.com>
 */
interface IFlow {
}

Boot::registerClass(IFlow::class, 'jotun.signals.IFlow');

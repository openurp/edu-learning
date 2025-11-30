/*
 * Copyright (C) 2014, The OpenURP Software.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package org.openurp.edu.learning.web.helper

import org.beangle.commons.lang.Numbers
import org.openurp.edu.grade.model.StdGpa

object RankHelper {

  def getRanks(gpas: Seq[StdGpa]): Map[StdGpa, Int] = {
    val ranks = getRanks(gpas.map(_.gpa))
    gpas.map(e => (e, ranks(e.gpa))).toMap
  }

  /** 1224排序，数值越大，排名越小
   * 默认保留2位小数
   *
   * @param scores
   * @param precision
   * @return
   */
  def getRanks(scores: Seq[Double], precision: Int = 2): Map[Double, Int] = {
    val rounded = scores.map(Numbers.round(_, precision))
    if (rounded.isEmpty) return Map.empty
    val sorted = rounded.sorted(Ordering[Double].reverse)

    // 计算排名映射
    val (_, rankMap) = sorted.foldLeft((0, Map.empty[Double, Int])) {
      case ((idx, map), current) =>
        val rank = map.getOrElse(current, idx + 1)
        val newMap = map.updated(current, rank)
        (idx + 1, newMap)
    }

    val ranks = rounded.map(rankMap(_))
    scores.zip(ranks).toMap
  }

  def main(args: Array[String]): Unit = {
    val data = List(95.5, 95.5000001, 90.0, 90.0000002, 85.5)
    getRanks(data) foreach { case (v, r) =>
      println(f"score:$v%.7f -> rank:$r")
    }
  }
}

# Implementation packets

Create one dated packet per authorized live change. The packet must name the
target, mutation, rollback, evidence destination, and exact canonical output
paths before execution. Mark every output path `create`, `update`, or
`not affected` with a reason. Keep the result with the packet after validation;
do not replace earlier packets.

Record the exact hv-cp commit that supplied the method or templates. An online
checkout must fetch before claiming it is current. An offline bundle checkout
must verify the explicitly approved commit and document that it cannot establish
remote currency.

Use `../templates/NODE_CONTROL_PLANE_CHECKLIST.md` as the starting checklist
and `../runbooks/CONTROLLED_CHANGE.md` as the execution discipline. A packet is
not complete until runtime acceptance and the canonical-node documentation
contract both pass.

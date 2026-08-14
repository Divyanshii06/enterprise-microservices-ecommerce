package com.ecommerce.order.controller;

import com.ecommerce.order.entity.Order;
import com.ecommerce.order.repository.OrderRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;

@RestController
@RequestMapping("/api/orders")
public class OrderController {

    private final OrderRepository orderRepository;

    public OrderController(OrderRepository orderRepository) {
        this.orderRepository = orderRepository;
    }

    // Sample secured endpoint demonstrating RBAC: only ORDER_MANAGER can process orders
    @PostMapping("/process")
    @PreAuthorize("hasRole('ORDER_MANAGER')")
    public ResponseEntity<?> processOrder(@RequestParam Long userId) {
        Order order = new Order("ORD-" + System.currentTimeMillis(), userId, 1, new BigDecimal("19.99"), "PROCESSED");
        Order saved = orderRepository.save(order);
        return ResponseEntity.ok(saved);
    }
}
